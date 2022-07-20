//
//  Expense.swift
//  WalletAnimation
//
//  Created by Алексей Зарицький on 12.06.2022.
//

import SwiftUI

// MARK: Expense Model and Sample Data

struct Expense: Identifiable{
    var id = UUID().uuidString
    var amountSpent: String
    var product: String
    var productIcon: String
    var spendType: String
}

var expenses: [Expense] = [

    Expense(amountSpent: "$128", product: "Amazon", productIcon: "Amazon", spendType: "Groceries"),
    Expense(amountSpent: "$20", product: "Youtube", productIcon: "Youtube", spendType: "Streaming"),
    Expense(amountSpent: "$10", product: "Dribbble", productIcon: "Dribbble", spendType: "Membership"),
    Expense(amountSpent: "$69", product: "Apple", productIcon: "Apple", spendType: "Apple Pay"),
    Expense(amountSpent: "$10", product: "Patreon", productIcon: "Patreon", spendType: "Membership"),
    Expense(amountSpent: "$30", product: "Instagram", productIcon: "Instagram", spendType: "Ad Publish"),
    Expense(amountSpent: "$12", product: "Netflix", productIcon: "Netflix", spendType: "Movies"),
    Expense(amountSpent: "$348", product: "Photoshop", productIcon: "Photoshop", spendType: "Editing"),
    Expense(amountSpent: "$100", product: "Figma", productIcon: "Figma", spendType: "Pro Member"),
]

