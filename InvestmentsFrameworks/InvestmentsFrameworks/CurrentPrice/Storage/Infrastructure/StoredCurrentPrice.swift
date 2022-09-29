//
//  StoredCurrentPrice.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 29.09.2022.
//

import CoreData

@objc(StoredCurrentPrice)
class StoredCurrentPrice: NSManagedObject {
    @NSManaged var ticket: String
    @NSManaged var price: Double
}

extension StoredCurrentPrice {
    static func first(with ticket: String, in context: NSManagedObjectContext) throws -> StoredCurrentPrice? {
        let request = NSFetchRequest<StoredCurrentPrice>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(StoredCurrentPrice.ticket), ticket])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        return try context.fetch(request).first
    }
    
    var currentPrice: CurrentPrice {
        CurrentPrice(price: price)
    }
}
