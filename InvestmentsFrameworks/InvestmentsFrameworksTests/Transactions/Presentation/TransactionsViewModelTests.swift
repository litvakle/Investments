//
//  TransactionsViewModelTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 14.09.2022.
//

import XCTest
import Combine
import InvestmentsFrameworks

class TransactionsViewModelTests: XCTestCase {
    func test_init_doesNotRequestsStore() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.retrievalRequests.count, 0)
        XCTAssertEqual(store.saveRequests.count, 0)
        XCTAssertEqual(store.deleteRequests.count, 0)
    }
    
    func test_retrieve_requestsStoreToRetrieveTransactions() {
        let (sut, store) = makeSUT()
        
        sut.retrieve()
        store.completeRetrieval(with: [])
        
        XCTAssertEqual(store.retrievalCallCount, 1)
    }
    
    func test_retrieve_receivesErrorOnStoreRetrivalError() {
        let (sut, store) = makeSUT()
            
        sut.retrieve()
        store.completeRetrieval(withError: anyNSError())
        
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
        
        sut.retrieve()
        store.completeRetrieval(with: transactions)
        
        XCTAssertEqual(sut.transactions, transactions.sorted(by: { $0.date > $1.date }))
    }
    
    func test_retrieve_togglesRetrievalIndicatorOnStartAndFinishRetrieval() {
        let (sut, store) = makeSUT()

        sut.retrieve()
        XCTAssertTrue(sut.isRetrieving)
        store.completeRetrieval(with: [], at: 0)
        XCTAssertFalse(sut.isRetrieving)

        sut.retrieve()
        store.completeRetrieval(withError: anyNSError(), at: 1)
        XCTAssertFalse(sut.isRetrieving)
    }
    
    func test_save_requestsStoreToSaveTransaction() {
        let (sut, store) = makeSUT()
        let transaction = makeTransaction()
        
        sut.save(transaction)
        store.completeSaveSuccessfully()
        
        XCTAssertEqual(store.savedTransactions, [transaction])
    }
    
    func test_save_receivesErrorOnStoreSavingError() {
        let (sut, store) = makeSUT()
        let transaction = makeTransaction()
        
        sut.save(transaction)
        store.completeSave(withError: anyNSError())
        
        XCTAssertEqual(sut.error as? NSError, anyNSError())
    }
    
    func test_save_savesTransactionAndSortTransactions() {
        let (sut, store) = makeSUT()
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
        let transaction0 = Transaction(date: oneMonthAgo, ticket: "QQQ", type: .sell, quantity: 1.5, price: 100, sum: 150)
        let transaction1 = Transaction(date: now, ticket: "VOO", type: .buy, quantity: 2, price: 250, sum: 500)
        
        sut.save(transaction0)
        sut.save(transaction1)
        store.completeSaveSuccessfully(at: 0)
        store.completeSaveSuccessfully(at: 1)
        
        XCTAssertEqual(sut.transactions, [transaction1, transaction0])
    }
    
    func test_save_overridesPreviouslyExistingTransactionWithTheSameID() {
        let (sut, store) = makeSUT()
        let id = UUID()
        let transaction0 = Transaction(id: id, date: Date(), ticket: "VOO", type: .buy, quantity: 1, price: 100, sum: 100)
        let transaction1 = Transaction(id: id, date: Date(), ticket: "XXX", type: .buy, quantity: 1, price: 100, sum: 100)
        
        sut.save(transaction0)
        sut.save(transaction1)
        store.completeSaveSuccessfully(at: 0)
        store.completeSaveSuccessfully(at: 1)
        
        XCTAssertEqual(sut.transactions, [transaction1])
    }
    
    func test_delete_requestsStoreToDeleteTransaction() {
        let (sut, store) = makeSUT()
        let transaction = makeTransaction()
        
        sut.delete(transaction)
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.deletedTransactions, [transaction])
    }
    
    func test_delete_receivesErrorOnStoreDeletionError() {
        let (sut, store) = makeSUT()
        let transaction = makeTransaction()
        
        sut.delete(transaction)
        store.completeDeletion(withError: anyNSError())
        
        XCTAssertEqual(sut.error as? NSError, anyNSError())
    }
    
    func test_delete_doesNotReceiveErrorOnNotFoundTransaction() {
        let (sut, store) = makeSUT()
        let transaction = makeTransaction()
        
        sut.delete(transaction)
        store.completeDeletionSuccessfully()
        
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.transactions, [])
    }
    
    func test_delete_deletesTransactions() {
        let (sut, store) = makeSUT()
        let transactions = makeTransactions()
        
        sut.save(transactions[0])
        sut.save(transactions[1])
        store.completeSaveSuccessfully(at: 0)
        store.completeSaveSuccessfully(at: 1)
        
        sut.delete(transactions[0])
        store.completeDeletionSuccessfully(at: 0)
        
        XCTAssertEqual(sut.transactions, [transactions[1]])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (TransactionsViewModel, StoreSpy) {
        let store = StoreSpy()
        let sut = TransactionsViewModel(retriever: store.retrievalPublisher, saver: store.savePublisher, deleter: store.deletePublisher)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
    
    private class StoreSpy {
        var retrievalRequests = [PassthroughSubject<[Transaction], Error>]()
        var saveRequests = [(transaction: Transaction, publisher: PassthroughSubject<Void, Error>)]()
        var deleteRequests = [(transaction: Transaction, publisher: PassthroughSubject<Void, Error>)]()
       
        var retrievalCallCount: Int {
            retrievalRequests.count
        }
        
        var savedTransactions: [Transaction] {
            saveRequests.map { $0.transaction }
        }
        
        var deletedTransactions: [Transaction] {
            deleteRequests.map { $0.transaction }
        }
        
        func retrievalPublisher() -> AnyPublisher<[Transaction], Error> {
            let publisher = PassthroughSubject<[Transaction], Error>()
            retrievalRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeRetrieval(withError error: Error, at index: Int = 0) {
            retrievalRequests[index].send(completion: .failure(error))
        }
        
        func completeRetrieval(with transactions: [Transaction], at index: Int = 0) {
            retrievalRequests[index].send(transactions)
            retrievalRequests[index].send(completion: .finished)
        }
        
        func savePublisher(for transaction: Transaction) -> AnyPublisher<Void, Error> {
            let publisher = PassthroughSubject<Void, Error>()
            saveRequests.append((transaction, publisher))
            return publisher.eraseToAnyPublisher()
        }
        
        func completeSave(withError error: Error, at index: Int = 0) {
            saveRequests[index].publisher.send(completion: .failure(error))
        }
        
        func completeSaveSuccessfully(at index: Int = 0) {
            saveRequests[index].publisher.send(())
            saveRequests[index].publisher.send(completion: .finished)
        }
        
        func deletePublisher(for transaction: Transaction) -> AnyPublisher<Void, Error> {
            let publisher = PassthroughSubject<Void, Error>()
            deleteRequests.append((transaction, publisher))
            return publisher.eraseToAnyPublisher()
        }
        
        func completeDeletion(withError error: Error, at index: Int = 0) {
            deleteRequests[index].publisher.send(completion: .failure(error))
        }
        
        func completeDeletionSuccessfully(at index: Int = 0) {
            deleteRequests[index].publisher.send(())
            deleteRequests[index].publisher.send(completion: .finished)
        }
    }
}
