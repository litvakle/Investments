//
//  TransactionsStorage.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 13.09.2022.
//

public typealias TransactionsStore = TransactionsRetriever & TransactionsSaver & TransactionsDeleter

public protocol TransactionsRetriever {
    func retrieve() throws -> [Transaction]
}

public protocol TransactionsSaver {
    func save(_ transaction: Transaction) throws
}

public protocol TransactionsDeleter {
    func delete(_ transaction: Transaction) throws
}
