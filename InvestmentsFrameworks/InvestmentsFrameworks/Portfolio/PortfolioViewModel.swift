//
//  PortfolioViewModel.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 26.09.2022.
//

import Foundation

public class PortfolioViewModel {
    private(set) public var items = [PortfolioItem]()
    
    public init() {}
    
    public func createItems(for transactions: [Transaction]) {
        var totalData = [String: (quantity: Double, sum: Double)]()
        transactions.forEach { transaction in
            let quantity = totalData[transaction.ticket]?.quantity ?? 0
            let sum = totalData[transaction.ticket]?.sum ?? 0
            totalData[transaction.ticket] = (quantity + transaction.quantity, sum + transaction.sum)
        }
        
        items = totalData.map { PortfolioItem(ticket: $0.key, quantity: $0.value.quantity, sum: $0.value.sum)}
            .sorted(by: { $0.ticket < $1.ticket })
    }
}

public struct PortfolioItem: Equatable {
    public let ticket: String
    public let quantity: Double
    public let sum: Double
    
    public init(ticket: String, quantity: Double, sum: Double) {
        self.ticket = ticket
        self.quantity = quantity
        self.sum = sum
    }
}
