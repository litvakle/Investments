//
//  CurrentPricesStore.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 28.09.2022.
//

public protocol CurrentPricesStore {
    func retrieve() throws -> CurrentPrices
    func save(_ currentPrice: CurrentPrice) throws
}

