//
//  CurrentPricesStore.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 28.09.2022.
//

public protocol CurrentPricesStore {
    func retrieve(for ticket: String) throws -> CurrentPrice?
    func save(_ currentPrice: CurrentPrice, for ticket: String) throws
}

