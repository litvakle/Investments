//
//  NullTransactionsStore.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 20.09.2022.
//

import Foundation
import InvestmentsFrameworks

class NullTransactionsStore: TransactionsStore {
    func retrieve() throws -> [InvestmentTransaction] {
        throw error()
    }
    
    func save(_ transaction: InvestmentTransaction) throws {
        throw error()
    }
    
    func delete(_ transaction: InvestmentTransaction) throws {
        throw error()
    }
    
    private func error() -> Error {
        NSError(domain: "Storage error", code: 0)
    }
}
