//
//  PortfolioViewModel.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 26.09.2022.
//

import Foundation

public class PortfolioViewModel: ObservableObject {
    @Published private(set) public var items = [PortfolioItem]()
    
    public init() {}
    
    public func createItems(for transactions: [Transaction], with currentPrices: CurrentPrices) {
        var totalData = [String: (quantity: Double, expenses: Double, income: Double)]()
        transactions.forEach { transaction in
            let ticket = transaction.ticket
            let type = transaction.type
            let quantity = transaction.quantity * (type == .buy ? 1 : -1)
            let expenses = transaction.sum * (type == .buy ? 1 : 0)
            let income = transaction.sum * (type == .buy ? 0 : 1)
            totalData[ticket] = (
                quantity: (totalData[ticket]?.quantity ?? 0) + quantity,
                expenses: (totalData[ticket]?.expenses ?? 0) + expenses,
                income: (totalData[ticket]?.income ?? 0) + income
            )
        }
        
        items = totalData.map { item in
            let ticket = item.key
            let price = currentPrices[ticket]?.price ?? 0
            let cost = item.value.quantity * price
            let profit = cost + item.value.income - item.value.expenses
            let profitPercent = profit / item.value.expenses
            
            return PortfolioItem(ticket: ticket, quantity: item.value.quantity, price: price, cost: cost, expenses: item.value.expenses, income: item.value.income, profit: profit, profitPercent: profitPercent)
        }.sorted(by: { $0.ticket < $1.ticket })
    }
}

public struct PortfolioItem: Equatable, Identifiable {
    public let ticket: String
    public let quantity: Double
    public let price: Double
    public let cost: Double
    public let expenses: Double
    public let income: Double
    public let profit: Double
    public let profitPercent: Double
    
    public var id: String {
        ticket
    }
    
    public init(ticket: String, quantity: Double, price: Double, cost: Double, expenses: Double, income: Double, profit: Double, profitPercent: Double) {
        self.ticket = ticket
        self.quantity = quantity
        self.price = price
        self.cost = cost
        self.expenses = expenses
        self.income = income
        self.profit = profit
        self.profitPercent = profitPercent
    }
}
