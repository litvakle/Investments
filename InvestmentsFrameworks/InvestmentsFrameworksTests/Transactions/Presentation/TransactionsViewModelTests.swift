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
    
    func save(_ transaction: Transaction) {
        do {
            try store.save(transaction)
            transactions.append(transaction)
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
    
    func test_save_requestsStoreToSaveTransaction() {
        let (sut, store) = makeSUT()
        let transaction = makeTransaction()
        
        sut.save(transaction)
        XCTAssertEqual(store.requests, [.save(transaction)])
    }
    
    func test_save_receivesErrorOnStoreSavingError() {
        let (sut, store) = makeSUT()
        let transaction = makeTransaction()
        
        store.completeSaving(withError: anyNSError())
        sut.save(transaction)
        
        XCTAssertEqual(sut.error as? NSError, anyNSError())
    }
    
    func test_save_savesTransactions() {
        let (sut, store) = makeSUT()
        let transactions = makeTransactions()
        
        store.completeSavingSuccessfully()
        sut.save(transactions[0])
        sut.save(transactions[1])
        
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
        private var saveResult: Result<Void, Error>?
        
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
            requests.append(.save(transaction))
            if case let .failure(error) = saveResult {
                throw error
            }
        }

        func completeSavingSuccessfully() {
            saveResult = .success(())
        }
        
        func completeSaving(withError: Error) {
            saveResult = .failure(anyNSError())
        }
        
        func delete(_ transaction: Transaction) throws {
            
        }
    }
}
