//
//  Transaction.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 13.09.2022.
//

import Foundation

public struct Transaction: Equatable, Identifiable {
    public let id: UUID
    public let date: Date
    public let ticket: String
    public let type: TransactionType
    public let quantity: Double
    public let price: Double
    public let sum: Double
    
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
