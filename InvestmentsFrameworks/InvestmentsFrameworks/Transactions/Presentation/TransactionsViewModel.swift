//
//  TransactionsViewModel.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 15.09.2022.
//

import Foundation

public class TransactionsViewModel: ObservableObject {
    private let store: TransactionsStore
    
    @Published public var error: Error?
    @Published public private(set) var transactions = [Transaction]()
    
    public init(store: TransactionsStore) {
        self.store = store
    }
    
    public func retrieve() {
        do {
            transactions = try store.retrieve().sorted(by: { $0.date > $1.date })
        } catch {
            self.error = error
        }
    }
    
    public func save(_ transaction: Transaction) {
        do {
            try store.save(transaction)
            if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
                transactions[index] = transaction
            } else {
                transactions.append(transaction)
            }
        } catch {
            self.error = error
        }
    }
    
    public func delete(_ transaction: Transaction) {
        do {
            try store.delete(transaction)
            if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
                transactions.remove(at: index)
            }
        } catch {
            self.error = error
        }
    }
}
