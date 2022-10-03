//
//  InMemoryTransactionsStore.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 21.09.2022.
//

import InvestmentsFrameworks

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
    static var empty: InMemoryStore {
        InMemoryStore(transactions: [], currentPrices: [:])
    }
    
    static var withStoredData: InMemoryStore {
        InMemoryStore(transactions: makePortfolioTransactions(), currentPrices: makeCurrentPrices())
    }
}
