//
//  TransactionsStorage.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 13.09.2022.
//

import Foundation

public final class TransactionsStorage {
    let store: TransactionsStore
    
    public enum RetrivalError: Error {
        case failed
    }
    
    public init(store: TransactionsStore) {
        self.store = store
    }
    
    public func retrieve() throws -> [Transaction] {
        do {
            return try store.retrieve()
        } catch {
            throw RetrivalError.failed
        }
    }
}

public protocol TransactionsStore {
    func retrieve() throws -> [Transaction]
    func save(transaction: Transaction) throws
    func delete(transaction: Transaction) throws
}
