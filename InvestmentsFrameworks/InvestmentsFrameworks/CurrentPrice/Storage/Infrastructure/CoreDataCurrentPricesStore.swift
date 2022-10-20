//
//  CoreDataCurrentPricesStore.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 28.09.2022.
//

import Foundation

extension CoreDataStore: CurrentPricesStore {
    public func retrieve(for ticket: String) throws -> CurrentPrice? {
        try performSync { context in
            Result {
                try StoredCurrentPrice.first(with: ticket, in: context)?.currentPrice
            }
        }
    }

    public func save(_ currentPrice: CurrentPrice, for ticket: String) throws {
        try performSync { context in
            Result {
                let storedCurrentPrice = try StoredCurrentPrice.first(with: ticket, in: context) ?? StoredCurrentPrice(context: context)
                storedCurrentPrice.ticket = ticket
                storedCurrentPrice.price = currentPrice.price
                
                try context.save()
            }
        }
    }
}
