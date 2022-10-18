//
//  NullTransactionsStore.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 20.09.2022.
//

import Foundation
import InvestmentsFrameworks

extension NullStore: CurrentPricesStore {
    public func save(_ currentPrice: CurrentPrice, for ticket: String) throws {
    }
    
    public func retrieve(for ticket: String) throws -> CurrentPrice? {
        return nil
    }
}
