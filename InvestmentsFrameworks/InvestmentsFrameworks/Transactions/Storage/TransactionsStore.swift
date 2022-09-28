//
//  TransactionsStorage.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 13.09.2022.
//

public protocol TransactionsStore {
    func retrieve() throws -> [Transaction]
    func save(_ transaction: Transaction) throws
    func delete(_ transaction: Transaction) throws
}
