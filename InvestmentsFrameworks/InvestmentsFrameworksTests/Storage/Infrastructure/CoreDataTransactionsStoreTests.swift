//
//  InvestmentsFrameworksTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 13.09.2022.
//

import XCTest
import InvestmentsFrameworks

class CoreDataTransactionsStoreTests: XCTestCase {
    func test_retreive_deliversEmptyTransactionsListOnEmptyStorage() throws {
        let sut = makeSUT()
        
        let retrievedTransactions = try sut.retrieve()
        
        XCTAssertEqual(retrievedTransactions, [])
    }
    
    func test_retreive_deliversStoredTransactionsOnNonEmptyStorage() throws {
        let sut = makeSUT()
        let transaction0 = Transaction(date: Date(), ticket: "VOO", type: .buy, quantity: 2, price: 250, sum: 500)
        let transaction1 = Transaction(date: Date(), ticket: "QQQ", type: .sell, quantity: 1.5, price: 100, sum: 150)
        
        save(transaction0, to: sut)
        save(transaction1, to: sut)
        let retrievedTransactions = try sut.retrieve()
        
        XCTAssertEqual(retrievedTransactions, [transaction0, transaction1])
    }
    
    func test_retrieve_deliversFailureOneRetrivalError() {
        let stub = NSManagedObjectContext.alwaysFailingFetchStub()
        stub.startIntercepting()
        let sut = makeSUT()
        
        do {
            _ = try sut.retrieve()
        } catch {
            XCTAssertEqual(error as NSError, anyNSError())
        }
    }
    
    func test_save_overridesTwiceSavedTransaction() throws {
        let sut = makeSUT()
        let transaction = Transaction(date: Date(), ticket: "VOO", type: .buy, quantity: 2, price: 250, sum: 500)
        
        save(transaction, to: sut)
        save(transaction, to: sut)
        
        let retrievedTransactions = try sut.retrieve()
        
        XCTAssertEqual(retrievedTransactions, [transaction])
    }
    
    func test_save_deliversFailureOneSaveError() {
        let transaction = Transaction(date: Date(), ticket: "VOO", type: .buy, quantity: 2, price: 250, sum: 500)
        let stub = NSManagedObjectContext.alwaysFailingSaveStub()
        stub.startIntercepting()
        let sut = makeSUT()
        
        do {
            _ = try sut.save(transaction)
        } catch {
            XCTAssertEqual(error as NSError, anyNSError())
        }
    }
    
    func test_delete_doesNothingOnNotFoundTransaction() throws {
        let sut = makeSUT()
        let transaction = Transaction(date: Date(), ticket: "VOO", type: .buy, quantity: 2, price: 250, sum: 500)
        
        let deletionError = delete(transaction, from: sut)
        XCTAssertNil(deletionError)

        let retrievedTransactions = try sut.retrieve()
        XCTAssertEqual(retrievedTransactions, [])
    }
    
    func test_delete_removesFoundTransaction() throws {
        let sut = makeSUT()
        let transaction0 = Transaction(date: Date(), ticket: "VOO", type: .buy, quantity: 2, price: 250, sum: 500)
        let transaction1 = Transaction(date: Date(), ticket: "QQQ", type: .sell, quantity: 1.5, price: 100, sum: 150)
        
        save(transaction0, to: sut)
        save(transaction1, to: sut)
        
        let deletionError = delete(transaction0, from: sut)
        XCTAssertNil(deletionError)

        let retrievedTransactions = try sut.retrieve()
        XCTAssertEqual(retrievedTransactions, [transaction1])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CoreDataTransactionsStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataTransactionsStore(storeURL: storeURL)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    @discardableResult
    private func save(_ transaction: Transaction, to sut: CoreDataTransactionsStore) -> Error? {
        do {
            try sut.save(transaction)
            return nil
        } catch {
            return error
        }
    }
    
    @discardableResult
    private func delete(_ transaction: Transaction, from sut: CoreDataTransactionsStore) -> Error? {
        do {
            try sut.delete(transaction)
            return nil
        } catch {
            return error
        }
    }
}