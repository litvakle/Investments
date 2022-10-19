//
//  InMemoryStore.swift
//  InvestmentsWatchOS WatchKit ExtensionTests
//
//  Created by Lev Litvak on 18.10.2022.
//

import Foundation
import InvestmentsFrameworksWatchOS

class InMemoryStore: TransactionsStore {
    var transactions: [Transaction]
    
    var currentPrices: CurrentPrices
    
    init(transactions: [Transaction], currentPrices: CurrentPrices) {
        self.transactions = transactions
        self.currentPrices = currentPrices
    }
    
    init(transactions: [Transaction]) {
        self.transactions = transactions
        self.currentPrices = [:]
    }
    
    init(currentPrices: CurrentPrices) {
        self.transactions = []
        self.currentPrices = currentPrices
    }
    
    func retrieve() throws -> [Transaction] {
        return transactions
    }
    
    func save(_ transaction: Transaction) throws {
        if let index = transactions.firstIndex(of: transaction) {
            transactions[index] = transaction
        } else {
            transactions.append(transaction)
        }
    }
    
    func delete(_ transaction: Transaction) throws {
        if let index = transactions.firstIndex(of: transaction) {
            transactions.remove(at: index)
        }
    }
}

extension InMemoryStore: CurrentPricesStore {
    func retrieve(for ticket: String) throws -> CurrentPrice? {
        currentPrices[ticket]
    }
    
    func save(_ currentPrice: CurrentPrice, for ticket: String) throws {
        currentPrices[ticket] = currentPrice
    }
}

extension InMemoryStore {
    static var withStoreData: InMemoryStore {
        InMemoryStore(transactions: [
            Transaction(ticket: "AAA", quantity: 10, price: 20, sum: 200),
            Transaction(ticket: "BBB", quantity: 5, price: 10, sum: 50)
        ], currentPrices: [:])
    }
}
