//
//  TransactionsViewModelTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 14.09.2022.
//

import XCTest
import InvestmentsFrameworks

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
    
    func test_retrieve_receivesRetrievedTransactionsAndSortThem() {
        let (sut, store) = makeSUT()
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
        let transactions = [
            Transaction(date: oneMonthAgo, ticket: "VOO", type: .buy, quantity: 2, price: 250, sum: 500),
            Transaction(date: now, ticket: "QQQ", type: .sell, quantity: 1.5, price: 100, sum: 150)
        ]
        
        store.completeRetrival(with: transactions)
        sut.retrieve()
        
        XCTAssertEqual(sut.transactions, transactions.sorted(by: { $0.date > $1.date }))
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
    
    func test_save_savesTransactionAndSortTransactions() {
        let (sut, store) = makeSUT()
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
        let transaction0 = Transaction(date: oneMonthAgo, ticket: "QQQ", type: .sell, quantity: 1.5, price: 100, sum: 150)
        let transaction1 = Transaction(date: now, ticket: "VOO", type: .buy, quantity: 2, price: 250, sum: 500)
        
        store.completeSavingSuccessfully()
        sut.save(transaction0)
        sut.save(transaction1)
        
        XCTAssertEqual(sut.transactions, [transaction1, transaction0])
    }
    
    func test_save_overridesPreviouslyExistingTransactionWithTheSameID() {
        let (sut, store) = makeSUT()
        let id = UUID()
        let transaction0 = Transaction(id: id, date: Date(), ticket: "VOO", type: .buy, quantity: 1, price: 100, sum: 100)
        let transaction1 = Transaction(id: id, date: Date(), ticket: "XXX", type: .buy, quantity: 1, price: 100, sum: 100)
        
        store.completeSavingSuccessfully()
        sut.save(transaction0)
        sut.save(transaction1)
        
        XCTAssertEqual(sut.transactions, [transaction1])
    }
    
    func test_delete_requestsStoreToDeleteTransaction() {
        let (sut, store) = makeSUT()
        let transaction = makeTransaction()
        
        sut.delete(transaction)
        XCTAssertEqual(store.requests, [.delete(transaction)])
    }
    
    func test_delete_receivesErrorOnStoreDeletionError() {
        let (sut, store) = makeSUT()
        let transaction = makeTransaction()
        
        store.completeDeletion(withError: anyNSError())
        sut.delete(transaction)
        
        XCTAssertEqual(sut.error as? NSError, anyNSError())
    }
    
    func test_delete_doesNotReceiveErrorOnNotFoundTransaction() {
        let (sut, store) = makeSUT()
        let transaction = makeTransaction()
        
        store.completeDeletionSuccessfully()
        sut.delete(transaction)
        
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.transactions, [])
    }
    
    func test_delete_deletesTransactions() {
        let (sut, store) = makeSUT()
        let transactions = makeTransactions()
        
        store.completeSavingSuccessfully()
        sut.save(transactions[0])
        sut.save(transactions[1])
        
        store.completeDeletionSuccessfully()
        sut.delete(transactions[0])
        
        XCTAssertEqual(sut.transactions, [transactions[1]])
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
        private var deletionResult: Result<Void, Error>?
        
        enum Request: Equatable {
            case retrieve
            case save(Transaction)
            case delete(Transaction)
        }
        
        func retrieve() throws -> [Transaction] {
            requests.append(.retrieve)
            
            return try retrivalResult?.get() ?? []
        }
        
        func completeRetrival(with transactions: [Transaction]) {
            retrivalResult = .success(transactions)
        }
        
        func completeRetrival(withError: Error) {
            retrivalResult = .failure(anyNSError())
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
            requests.append(.delete(transaction))
            if case let .failure(error) = deletionResult {
                throw error
            }
        }
        
        func completeDeletionSuccessfully() {
            deletionResult = .success(())
        }
        
        func completeDeletion(withError: Error) {
            deletionResult = .failure(anyNSError())
        }
    }
}
