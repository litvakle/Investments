//
//  NullTransactionsStore.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 20.09.2022.
//

import Foundation
import InvestmentsFrameworks

class NullStore {}

extension NullStore: TransactionsStore {
    func retrieve() throws -> [InvestmentTransaction] {
        return []
    }
    
    func save(_ transaction: InvestmentTransaction) throws {
    }
    
    func delete(_ transaction: InvestmentTransaction) throws {
    }
}

extension NullStore: CurrentPricesStore {
    func save(_ currentPrice: CurrentPrice, for ticket: String) throws {
    }
    
    func retrieve(for ticket: String) throws -> CurrentPrice? {
        return nil
    }
}
