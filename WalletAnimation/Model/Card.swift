//
//  Card.swift
//  WalletAnimation
//
//  Created by Алексей Зарицький on 10.06.2022.
//

import SwiftUI

// MARK: Sample Card  Model and Data
struct Card: Identifiable{
    var id = UUID().uuidString
    var name: String
    var cardNumber: String
    var cardImage: String
}

var cards: [Card] = [

    Card(name: "IAlex", cardNumber: "4345 5687 7867 4444", cardImage: "Card1"),
    Card(name: "Sandra", cardNumber: "5687  4345 7867 5687", cardImage: "Card2"),
    Card(name: "Kris", cardNumber: "7867 4345 5687 0105", cardImage: "Card3"),
]
