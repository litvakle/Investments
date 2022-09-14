//
//  TransactionsViewModelTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 14.09.2022.
//

import XCTest
import InvestmentsFrameworks

class TransactionsViewModel {
    private let store: TransactionsStore
    
    init(store: TransactionsStore) {
        self.store = store
    }
}

class TransactionsViewModelTests: XCTestCase {
    func test_init_doesNotRequestsStore() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.requests, [])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: TransactionsViewModel, store: StoreSpy) {
        let store = StoreSpy()
        let sut = TransactionsViewModel(store: store)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
    
    private class StoreSpy: TransactionsStore {
        private(set) var requests = [Request]()
        
        enum Request: Equatable {
            case retrieve
            case save(Transaction)
            case delete(Transaction)
        }
        
        func retrieve() throws -> [Transaction] {
            return []
        }
        
        func save(_ transaction: Transaction) throws {
            
        }
        
        func delete(_ transaction: Transaction) throws {
            
        }
        
        
    }
}
