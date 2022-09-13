//
//  InvestmentsFrameworksTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 13.09.2022.
//

import XCTest
import InvestmentsFrameworks

class TransactionsStorageUsecaseTests: XCTestCase {
    func test_init_doesNotRequestStore() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.requests, [])
    }
    
    // MARK: - Herlpers
    
    private func makeSUT() -> (TransactionsStorage, StoreSpy) {
        let store = StoreSpy()
        let storage = TransactionsStorage(store: store)
        
        return (storage, store)
    }
    
    private class StoreSpy: TransactionsStore {
        private(set) var requests = [Request]()
        
        enum Request: Equatable {
            
        }
    }
}
