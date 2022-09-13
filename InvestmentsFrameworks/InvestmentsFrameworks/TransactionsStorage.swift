//
//  TransactionsStorage.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 13.09.2022.
//

import Foundation

public protocol TransactionsStore {
    func retrieve() throws -> [Transaction]
    func save(transaction: Transaction) throws
    func delete(transaction: Transaction) throws
}
