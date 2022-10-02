//
//  TransactionsStoreFactory.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 21.09.2022.
//

import InvestmentsFrameworks
import CoreData

enum TransactionsStoreFactory {
    static func create() -> TransactionsStore & CurrentPricesStore {
        do {
            return try CoreDataStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("transactions-store.sqlite")
                )
        } catch {
            return NullStore()
        }
    }
}
