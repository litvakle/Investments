//
//  TransactionsViewModelTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 14.09.2022.
//

import XCTest
import InvestmentsFrameworks

class TransactionsViewModel: ObservableObject {
    private let store: TransactionsStore
    var error: Error?
    var transactions = [Transaction]()
    
    init(store: TransactionsStore) {
        self.store = store
    }
    
    func retrieve() {
        do {
            transactions = try store.retrieve()
        } catch {
            self.error = error
        }
    }
}

class TransactionsViewModelTests: XCTestCase {
    func test_init_doesNotRequestsStore() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.requests, [])
    }
    
    func test_retrieve_requestsStoreToRetrieveTransactions() {
        let (sut, store) = makeSUT()
        
        sut.retrieve()
        
        XCTAssertEqual(store.requests, [.retrieve])
    }
    
    func test_retrieve_receivesErrorOnStoreRetrivalError() {
        let (sut, store) = makeSUT()
            
        store.completeRetrival(withError: anyNSError())
        sut.retrieve()
        
        XCTAssertEqual(sut.error as? NSError, anyNSError())
    }
    
    func test_retrieve_receivesRetrievedTransactions() {
        let (sut, store) = makeSUT()
        let transactions = makeTransactions()
        
        store.completeRetrival(with: transactions)
        sut.retrieve()
        
        XCTAssertEqual(sut.transactions, transactions)
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
        
        private var retrivalResult: Result<[Transaction], Error>?
        
        enum Request: Equatable {
            case retrieve
            case save(Transaction)
            case delete(Transaction)
        }
        
        func retrieve() throws -> [Transaction] {
            requests.append(.retrieve)
            
            return try retrivalResult?.get() ?? []
        }
        
        func completeRetrival(withError: Error) {
            retrivalResult = .failure(anyNSError())
        }
        
        func completeRetrival(with transactions: [Transaction]) {
            retrivalResult = .success(transactions)
        }
        
        func save(_ transaction: Transaction) throws {
            
        }
        
        func delete(_ transaction: Transaction) throws {
            
        }
    }
}
