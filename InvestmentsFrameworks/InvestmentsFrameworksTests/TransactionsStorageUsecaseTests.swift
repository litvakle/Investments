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
    
    // MARK: - Helpers
    
    private func makeSUT() -> CoraDataTransactionsStore {
        return CoraDataTransactionsStore()
    }
}
