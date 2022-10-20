//
//  CoreDataTransactionsStore+TransactionsStore.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 14.09.2022.
//

import CoreData

extension CoreDataStore: TransactionsStore {
    public func retrieve() throws -> [Transaction] {
        try performSync { context in
            Result {
                try StoredTransaction.allTransactions(in: context)
            }
        }
    }

    public func save(_ transaction: Transaction) throws {
        try performSync { context in
            Result {
                let storedTransaction = try StoredTransaction.first(with: transaction.id, in: context) ?? StoredTransaction(context: context)
                storedTransaction.id = transaction.id
                storedTransaction.date = transaction.date
                storedTransaction.type = transaction.type.asString()
                storedTransaction.ticket = transaction.ticket
                storedTransaction.quantity = transaction.quantity
                storedTransaction.price = transaction.price
                storedTransaction.sum = transaction.sum

                try context.save()
            }
        }
    }

    public func delete(_ transaction: Transaction) throws {
        try performSync { context in
            Result {
                try StoredTransaction.first(with: transaction.id, in: context)
                    .map(context.delete)
                    .map(context.save)
            }
        }
    }
}
