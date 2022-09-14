//
//  Transaction.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 13.09.2022.
//

import Foundation

public struct Transaction: Equatable {
    let id: UUID
    let date: Date
    let ticket: String
    let type: TransactionType
    let quantity: Double
    let price: Double
    let sum: Double
    
    public init(id: UUID = UUID(), date: Date, ticket: String, type: TransactionType, quantity: Double, price: Double, sum: Double) {
        self.id = id
        self.date = date
        self.ticket = ticket
        self.type = type
        self.quantity = quantity
        self.price = price
        self.sum = sum
    }
}

public enum TransactionType {
    case buy
    case sell
}