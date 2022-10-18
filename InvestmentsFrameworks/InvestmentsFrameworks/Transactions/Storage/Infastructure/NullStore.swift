//
//  NullStore.swift
//  InvestmentsFrameworks
//
//  Created by Bogdan on 18.10.2022.
//

import Foundation

public class NullStore {
    public init() {}
}

extension NullStore: TransactionsStore {
    public func retrieve() throws -> [Transaction] { [] }
    public func save(_ transaction: Transaction) throws {}
    public func delete(_ transaction: Transaction) throws {}
}
