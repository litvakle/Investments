//
//  TransactionsStorage.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 13.09.2022.
//

import Foundation

public final class TransactionsStorage {
    let store: TransactionsStore
    
    public init(store: TransactionsStore) {
        self.store = store
    }
}

public protocol TransactionsStore {}
