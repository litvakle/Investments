//
//  CoreDataCurrentPricesStoreTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 28.09.2022.
//

import XCTest
import InvestmentsFrameworks
import CoreData

class CoreDataCurrentPricesStoreTests: XCTestCase {
    func test_retreive_deliversNilOnNotFoundInStorage() throws {
        let sut = makeSUT()
        let ticket = "AAA"
        
        let retrievedPrice = try sut.retrieve(for: ticket)
        
        XCTAssertNil(retrievedPrice)
    }
    
    func test_retreive_deliversStoredCurrentPriceOnFoundInStore() throws {
        let sut = makeSUT()
        
        save(CurrentPrice(price: 100), for: "AAA", to: sut)
        save(CurrentPrice(price: 200), for: "BBB", to: sut)
        
        XCTAssertEqual(try sut.retrieve(for: "AAA")?.price, 100)
        XCTAssertEqual(try sut.retrieve(for: "BBB")?.price, 200)
    }
    
    func test_retrieve_deliversFailureOneRetrivalError() {
        let stub = NSManagedObjectContext.alwaysFailingFetchStub()
        stub.startIntercepting()
        let sut = makeSUT()
        
        do {
            _ = try sut.retrieve(for: "AAA")
        } catch {
            XCTAssertEqual(error as NSError, anyNSError())
        }
    }
    
    func test_save_overridesPreviouslySavedPrice() throws {
        let sut = makeSUT()
        let ticket = "AAA"
        let currentPrice0 = CurrentPrice(price: 100)
        let currentPrice1 = CurrentPrice(price: 200)
        
        save(currentPrice0, for: ticket, to: sut)
        save(currentPrice1, for: ticket, to: sut)
        
        XCTAssertEqual(try sut.retrieve(for: ticket), currentPrice1)
    }
    
    func test_save_deliversFailureOneSaveError() {
        let currentPrice = CurrentPrice(price: 100)
        let stub = NSManagedObjectContext.alwaysFailingSaveStub()
        stub.startIntercepting()
        let sut = makeSUT()
        
        do {
            _ = try sut.save(currentPrice, for: "AAA")
        } catch {
            XCTAssertEqual(error as NSError, anyNSError())
        }
    }
    
    func test_save_hasNoSideEffectsOnSaveError() throws {
        let currentPrice = CurrentPrice(price: 100)
        let ticket = "AAA"
        let stub = NSManagedObjectContext.alwaysFailingSaveStub()
        stub.startIntercepting()
        let sut = makeSUT()
        
        save(currentPrice, for: ticket, to: sut)
        
        XCTAssertNil(try sut.retrieve(for: ticket))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CoreDataStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataStore(storeURL: storeURL)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    @discardableResult
    private func save(_ transaction: Transaction, to sut: CoreDataStore) -> Error? {
        do {
            try sut.save(transaction)
            return nil
        } catch {
            return error
        }
    }
    
    @discardableResult
    private func delete(_ transaction: Transaction, from sut: CoreDataStore) -> Error? {
        do {
            try sut.delete(transaction)
            return nil
        } catch {
            return error
        }
    }
    
    @discardableResult
    private func save(_ currentPrice: CurrentPrice, for ticket: String, to sut: CoreDataStore) -> Error? {
        do {
            try sut.save(currentPrice, for: ticket)
            return nil
        } catch {
            return error
        }
    }
}
