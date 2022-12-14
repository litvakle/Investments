//
//  InvestmentsFrameworksTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 13.09.2022.
//

import XCTest
import InvestmentsFrameworks
import CoreData

class CoreDataTransactionsStoreTests: XCTestCase {
    func test_retreive_deliversEmptyTransactionsListOnEmptyStorage() throws {
        let sut = makeSUT()
        
        let retrievedTransactions: [Transaction] = try sut.retrieve()
        
        XCTAssertEqual(retrievedTransactions, [])
    }
    
    func test_retreive_deliversStoredTransactionsOnNonEmptyStorage() throws {
        let sut = makeSUT()
        let transactions = makeTransactions()
        
        save(transactions[0], to: sut)
        save(transactions[1], to: sut)
        let retrievedTransactions: [Transaction] = try sut.retrieve()
        
        XCTAssertEqual(retrievedTransactions, transactions)
    }
    
    func test_retrieve_deliversFailureOneRetrivalError() {
        let stub = NSManagedObjectContext.alwaysFailingFetchStub()
        stub.startIntercepting()
        let sut = makeSUT()
        
        do {
            let _: [Transaction] = try sut.retrieve()
        } catch {
            XCTAssertEqual(error as NSError, anyNSError())
        }
    }
    
    func test_save_overridesTwiceSavedTransaction() throws {
        let sut = makeSUT()
        let transaction = makeTransaction()
        
        save(transaction, to: sut)
        save(transaction, to: sut)
        
        let retrievedTransactions: [Transaction] = try sut.retrieve()
        
        XCTAssertEqual(retrievedTransactions, [transaction])
    }
    
    func test_save_deliversFailureOneSaveError() {
        let transaction = makeTransaction()
        let stub = NSManagedObjectContext.alwaysFailingSaveStub()
        stub.startIntercepting()
        let sut = makeSUT()
        
        do {
            _ = try sut.save(transaction)
        } catch {
            XCTAssertEqual(error as NSError, anyNSError())
        }
    }
    
    func test_save_hasNoSideEffectsOnSaveError() throws {
        let transaction = makeTransaction()
        let stub = NSManagedObjectContext.alwaysFailingSaveStub()
        stub.startIntercepting()
        let sut = makeSUT()
        
        save(transaction, to: sut)
        let retrievedTransactions: [Transaction] = try sut.retrieve()
        
        XCTAssertEqual(retrievedTransactions, [])
    }
    
    func test_delete_doesNothingOnNotFoundTransaction() throws {
        let sut = makeSUT()
        let transaction = makeTransaction()
        
        let deletionError = delete(transaction, from: sut)
        XCTAssertNil(deletionError)

        let retrievedTransactions: [Transaction] = try sut.retrieve()
        XCTAssertEqual(retrievedTransactions, [])
    }
    
    func test_delete_removesFoundTransaction() throws {
        let sut = makeSUT()
        let transactions = makeTransactions()
        
        save(transactions[0], to: sut)
        save(transactions[1], to: sut)
        
        let deletionError = delete(transactions[0], from: sut)
        XCTAssertNil(deletionError)

        let retrievedTransactions: [Transaction] = try sut.retrieve()
        XCTAssertEqual(retrievedTransactions, [transactions[1]])
    }
    
    func test_delete_deliversFailureOneDeletionError() {
        let transaction = makeTransaction()
        let stub = NSManagedObjectContext.alwaysFailingSaveStub()
        let sut = makeSUT()
        
        try? sut.save(transaction)
        XCTAssertEqual(try sut.retrieve(), [transaction])
        
        stub.startIntercepting()

        do {
            try sut.delete(transaction)
        } catch {
            XCTAssertEqual(error as NSError, anyNSError())
        }
    }
    
    func test_delete_hasNoSideEffectsOnDeletionError() {
        let transaction = makeTransaction()
        let stub = NSManagedObjectContext.alwaysFailingSaveStub()
        let sut = makeSUT()
        
        try? sut.save(transaction)
        XCTAssertEqual(try sut.retrieve(), [transaction])
        
        stub.startIntercepting()
        
        try? sut.delete(transaction)
        XCTAssertEqual(try sut.retrieve(), [transaction])
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
}
