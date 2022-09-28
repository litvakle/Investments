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
    
    public init(id: UUID = UUID(), date: Date = Date(), ticket: String = "", type: TransactionType = .buy, quantity: Double = 0, price: Double = 0, sum: Double = 0) {
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
