//
//  InMemoryTransactionsStore.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 21.09.2022.
//

import InvestmentsFrameworks

class InMemoryTransactionsStore: TransactionsStore {
    var transactions = [
        Transaction(ticket: "VOO", type: .buy, quantity: 2, price: 10, sum: 20),
        Transaction(ticket: "QQQ", type: .sell, quantity: 1, price: 100, sum: 100)
    ]
    
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
