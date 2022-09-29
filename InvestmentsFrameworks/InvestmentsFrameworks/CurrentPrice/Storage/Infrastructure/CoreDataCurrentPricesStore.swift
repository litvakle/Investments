//
//  CoreDataCurrentPricesStore.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 28.09.2022.
//

import Foundation

extension CoreDataStore: CurrentPricesStore {
    public func retrieve() throws -> CurrentPrices {
        return CurrentPrices()
    }

    public func save(_ currentPrice: CurrentPrice) throws {
        
    }
}
