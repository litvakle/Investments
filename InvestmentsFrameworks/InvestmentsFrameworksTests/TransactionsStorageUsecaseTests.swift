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
        let transactions = [
            Transaction(date: Date(), ticket: "VOO", type: .buy, quantity: 2, price: 250, sum: 500),
            Transaction(date: Date(), ticket: "QQQ", type: .sell, quantity: 1.5, price: 100, sum: 150)
        ]
        
        save(transactions, to: sut)
        let retrievedTransactions = try sut.retrieve()
        
        XCTAssertEqual(retrievedTransactions, transactions)
    }
    
    func test_save_overridesTwiceSavedTransaction() throws {
        let sut = makeSUT()
        let transactions = [Transaction(date: Date(), ticket: "VOO", type: .buy, quantity: 2, price: 250, sum: 500)]
        
        save(transactions, to: sut)
        save(transactions, to: sut)
        
        let retrievedTransactions = try sut.retrieve()
        
        XCTAssertEqual(retrievedTransactions, transactions)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> CoreDataTransactionsStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataTransactionsStore(storeURL: storeURL)
        
        return sut
    }
    
    @discardableResult
    private func save(_ transactions: [Transaction], to sut: CoreDataTransactionsStore) -> Error? {
        do {
            try sut.save(transactions)
            return nil
        } catch {
            return error
        }
    }
}
