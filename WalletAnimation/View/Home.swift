//
//  Home.swift
//  WalletAnimation
//
//  Created by Алексей Зарицький on 10.06.2022.
//

import SwiftUI

struct Home: View {
    // MARK: Animation Properties
    @State var expandCards: Bool = false
    
    // MARK: Deetail View Properties
    @State var currentCard:  Card?
    @State var showDetailCard: Bool = false
    @Namespace var animation
    var body: some View {
        VStack(spacing: 0){
            
            
            Text("Wallet")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity,alignment: expandCards ? .leading: .center)
                .overlay(alignment: .trailing) {
                    
                    // MARK: Close Button
                    Button {
                        // Closing Cards
                        withAnimation(
                            .interactiveSpring(response: 0.8,
                            dampingFraction: 0.7,
                            blendDuration: 0.7)){
                                expandCards = false
                        }
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.7),in: Circle())
                    }
                    .rotationEffect(.init(degrees: expandCards ? 45 : 0))
                    .offset(x: expandCards ? 10 : 15)
                    .opacity(expandCards ? 1 : 0)
                }
                .padding(.horizontal, 15)
                .padding(.bottom,10)
            
            ScrollView(.vertical, showsIndicators: false){
                
                VStack(spacing: 0){
                    
                    // MARK: Cards
                    ForEach(cards){card in
                        //  If you want pure transion without this little opacity change in the sense just remove this if...else condition
                        Group {
                            if currentCard?.id == card.id && showDetailCard{
                                CardView(card: card)
                                    .opacity(0)
                            }
                            else {
                                CardView(card: card)
                                    .matchedGeometryEffect(id: card.id, in: animation)
                            }
                        }
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.35)){
                                    currentCard = card
                                    showDetailCard = true
                                }
                            }
                    }
                }
                .overlay{
                    // TO Avoid Scrolling
                    Rectangle()
                        .fill(.black.opacity(expandCards ? 0 : 0.01))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.35)){
                                expandCards = true
                            }
                        }
                }
                .padding(.top,expandCards ? 30 : 0)
            }
            .coordinateSpace(name: "SCROLL")
            .offset(y: expandCards ? 0 : 30)
            
            // MARK: Add Button
            
            Button {
            } label: {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(Color.black.opacity(0.7),in: Circle())
            }
            .rotationEffect(.init(degrees: expandCards ? 180 : 0))
              // To Avoid Warning 0.01
            .scaleEffect(expandCards ? 0.01 : 1)
            .opacity(!expandCards ? 1 : 0)
            .frame(height: expandCards ? 0 : nil)
            .padding(.bottom,expandCards ? 0 : 30)
        }
        .padding([.horizontal,.top])
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .overlay {
            if let currentCard = currentCard,showDetailCard {
                DetailView(currentCard: currentCard, showDetailCard: $showDetailCard,animation: animation)
            }
        }
    }
    
    //MARK: CArd View
    @ViewBuilder
    func CardView(card: Card)->some View{
        GeometryReader{proxy in
                        
            let rect = proxy.frame(in: .named("SCROLL"))
            // Lets dispaly some Portion of each Card
            let offset = CGFloat(getIndex(Card: card) * (expandCards ? 10 : 70))
            
            ZStack(alignment: .bottomLeading) {
                
                  Image(card.cardImage)
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      
                  
                
                // Card Details
                VStack(alignment: .leading, spacing: 10) {
                    
                    
                    Text(card.name)
                        .fontWeight(.bold)
                    
                    Text(customisedCardNumber(number: card.cardNumber))
                        .font(.callout)
                        .fontWeight(.bold)

                }
                .padding()
                .padding(.bottom,10)
                .foregroundColor(.white)
            }
            // Making it as Stack
            .offset(y: expandCards ? offset : -rect.minY +  offset)
            
        }
        // Max Size
        .frame(height: 200)
    }
    
    // Retreiving Index
    func getIndex(Card: Card)->Int{
        return cards.firstIndex {  currentCard in
            return currentCard.id == Card.id
        } ?? 0
      }
   }

// MARK: Hiding all Number expect last four
// Global Method
func customisedCardNumber(number: String)->String{
    var newValue: String = ""
    let maxCount = number.count - 4
    
    number.enumerated().forEach { value in
        if value.offset >= maxCount{
            //Display Text
            let string = String(value.element)
            newValue.append(contentsOf: string)
        }
        else{
            // Simply Display Star
            // Avoiding Space
            let string = String(value.element)
            if string == " "{
                newValue.append(contentsOf: " ")
            }
            else{
            newValue.append(contentsOf: "*")
            }
        }
    }
    
    return newValue
 }


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: Detail View
struct DetailView: View{
    var currentCard: Card
    @Binding var showDetailCard: Bool
      //  Mathed Geometry Effect
    var animation: Namespace.ID
    
    // Delaying Expenses View
    @State var showExpenseView: Bool = false
    
    var body: some View{
        
        VStack{
            CardView()
                .matchedGeometryEffect(id: currentCard.id, in: animation)
                .frame(height: 200)
                .onTapGesture {
                    // Closing Expense View First
                    withAnimation(.easeInOut){
                        showExpenseView = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        
                        withAnimation(.easeInOut(duration: 0.35)){
                            showDetailCard = false
                        }
                    }
                }
                .zIndex(10)
            
            GeometryReader{proxy in
                
                let height = proxy.size.height + 50
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 20){
                        
                        // Expense
                        ForEach(expenses){expense in
                            // Card View
                            ExpenseCardView(expense: expense)
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity)
                .background(
                    Color.white
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .ignoresSafeArea()
                )
                .offset(y: showExpenseView ? 0 : height)
            }
            .padding([.horizontal,.top])
            .zIndex(-10)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        .background(Color("BG").ignoresSafeArea())
        .onAppear {
            withAnimation(.easeInOut.delay(0.1)){
                showExpenseView = true
            }
        }
    }
    
    @ViewBuilder
    func CardView()->some View{
        ZStack(alignment: .bottomLeading) {
            
              Image(currentCard.cardImage)
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  
              
            
            // Card Details
            VStack(alignment: .leading, spacing: 10) {
                
                
                Text(currentCard.name)
                    .fontWeight(.bold)
                
                Text(customisedCardNumber(number: currentCard.cardNumber))
                    .font(.callout)
                    .fontWeight(.bold)

            }
            .padding()
            .padding(.bottom,10)
            .foregroundColor(.white)
        }
    }
}


struct ExpenseCardView: View{
    var expense: Expense
    // Dispalying  Expense one by one Based on Index
    @State var showView: Bool = false
    var body: some View{
        HStack(spacing: 14){
            Image(expense.productIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 45, height: 45)
               
            VStack(alignment: .leading, spacing: 8){
                
                Text(expense.product)
                    .fontWeight(.bold)
                
                Text(expense.spendType)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            
            VStack(spacing: 8){
                
                Text(expense.amountSpent)
                    .fontWeight(.bold)
                
                Text(Date().formatted(date: .numeric, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .opacity(showView ? 1 : 0)
        onAppear{
            // Time Taken for To show up
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.3).delay(Double(getIndex()) * 0.1)){
                    showView = true
                }
            }
        }
    }
    
    func getIndex()->Int{
        return expenses.firstIndex { currentExpense in
            return expense.id == currentExpense.id
        } ?? 0
    }
}
