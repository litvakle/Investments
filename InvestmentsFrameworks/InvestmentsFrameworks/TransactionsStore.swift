//
//  TransactionsStorage.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 13.09.2022.
//

import CoreData

public protocol TransactionsStore {
    func retrieve() throws -> [Transaction]
    func save(transaction: Transaction) throws
    func delete(transaction: Transaction) throws
}

public class CoreDataTransactionsStore {
    private static let modelName = "TransactionsStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataTransactionsStore.self))
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    public init(storeURL: URL) throws {
        guard let model = Self.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            container = try NSPersistentContainer.load(name: Self.modelName, model: model, url: storeURL)
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait { result = action(context) }
        
        return try result.get()
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
    
    public func retrieve() throws -> [Transaction] {
        try performSync { context in
            Result {
                try StoredTransaction.allTransactions(in: context)
            }
        }
    }
    
    public func save(_ transactions: [Transaction]) throws {
        try performSync { context in
            Result {
                try transactions.forEach { transaction in
                    let storedTransaction = try StoredTransaction.first(with: transaction.id, in: context)
                    storedTransaction.id = transaction.id
                    storedTransaction.date = transaction.date
                    storedTransaction.type = transaction.type.asString()
                    storedTransaction.ticket = transaction.ticket
                    storedTransaction.quantity = transaction.quantity
                    storedTransaction.price = transaction.price
                    storedTransaction.sum = transaction.sum

                    try context.save()
                }
            }
        }
    }
}
