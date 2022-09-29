//
//  CoreDataCurrentPricesStore.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 28.09.2022.
//

import Foundation

extension CoreDataStore: CurrentPricesStore {
    public func retrieve(for ticket: String) throws -> CurrentPrice? {
        return nil
    }

    public func save(_ currentPrice: CurrentPrice) throws {
        
    }
}
