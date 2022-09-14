//
//  StoredTransaction.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 13.09.2022.
//

import CoreData

@objc(StoredTransaction)
class StoredTransaction: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var date: Date
    @NSManaged var type: String
    @NSManaged var ticket: String
    @NSManaged var quantity: Double
    @NSManaged var price: Double
    @NSManaged var sum: Double
}

extension TransactionType {
    func asString() -> String {
        return self == .buy ? "buy" : "sell"
    }
    
    static func fromString(_ type: String) -> TransactionType {
        return type == "buy" ? .buy : .sell
    }
}

extension StoredTransaction {
    static func find(in context: NSManagedObjectContext) throws -> StoredTransaction? {
        let request = NSFetchRequest<StoredTransaction>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func allTransactions(in context: NSManagedObjectContext) throws -> [Transaction] {
        let request = NSFetchRequest<StoredTransaction>(entityName: entity().name!)
        let sortByDate = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortByDate]
        
        return try context.fetch(request).map{ $0.transaction }
    }
    
    static func first(with id: UUID, in context: NSManagedObjectContext) throws -> StoredTransaction {
        let request = NSFetchRequest<StoredTransaction>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(StoredTransaction.id), id])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        return try context.fetch(request).first ?? StoredTransaction(context: context)
    }
    
    var transaction: Transaction {
        return Transaction(
            id: id,
            date: date,
            ticket: ticket,
            type: TransactionType.fromString(type),
            quantity: quantity,
            price: price,
            sum: sum
        )
    }
}
