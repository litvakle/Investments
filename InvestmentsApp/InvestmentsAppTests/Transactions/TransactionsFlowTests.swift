//
//  TransactionsFlowTests.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 20.09.2022.
//

import XCTest
import Combine
import InvestmentsFrameworks
@testable import InvestmentsApp

class TransactionsFlowTests: XCTestCase {
    func test_transactionsError_leadsToAlert() {
        let store = TransactionsStoreStub()
        let transactionsViewModel = TransactionsViewModel(store: store)
        let alertViewModel = AlertViewModel()
        let sut = TransactionsFlow()
        sut.setupSubscriptions(
            transactionsViewModel: transactionsViewModel,
            alertViewModel: alertViewModel
        )
        
        XCTAssertFalse(alertViewModel.isActive)
        XCTAssertTrue(alertViewModel.title.isEmpty)
        XCTAssertTrue(alertViewModel.message.isEmpty)
        
        transactionsViewModel.error = anyNSError()
        
        XCTAssertEqual(alertViewModel.isActive, true)
        XCTAssertFalse(alertViewModel.title.isEmpty)
        XCTAssertFalse(alertViewModel.message.isEmpty)
    }
    
    func test_transactionsFlow_MakesPutRequestOnStoredTransactions() {
        let store = InMemoryStore.withStoredData
        let transactionsViewModel = TransactionsViewModel(store: store)
        let sut = TransactionsFlow()
        let httpClient = HTTPClientSpy()
        
        transactionsViewModel.retrieve()
        sut.setupSubscriptions(
            transactionsViewModel: transactionsViewModel,
            httpClient: httpClient,
            url: URL(string: "http://any-url.com")!
        )
        
        XCTAssertEqual(httpClient.putRequestsCallCount, 1)
    }
    
    func test_transactionsFlow_DoesNotMakePutRequestOnNoStoredTransactions() {
        let store = InMemoryStore.empty
        let transactionsViewModel = TransactionsViewModel(store: store)
        let sut = TransactionsFlow()
        let httpClient = HTTPClientSpy()
        
        transactionsViewModel.retrieve()
        sut.setupSubscriptions(
            transactionsViewModel: transactionsViewModel,
            httpClient: httpClient,
            url: URL(string: "http://any-url.com")!
        )
        
        XCTAssertEqual(httpClient.putRequestsCallCount, 0)
    }
    
    // MARK: - Helpers
    
    private class TransactionsStoreStub: TransactionsStore {
        func retrieve() throws -> [Transaction] {
            [
                Transaction(id: UUID(uuidString: "1870AAF2-1DF7-4114-B845-BAFB0B0E4138")!, date: Date(timeIntervalSince1970: 1598627222), ticket: "AAA", type: .buy, quantity: 10, price: 2, sum: 20),
                Transaction(id: UUID(uuidString: "3F9EE62C-90E9-4EFB-847F-A9ED0443FA97")!, date: Date(timeIntervalSince1970: 1577881882), ticket: "BBB", type: .sell, quantity: 5, price: 20, sum: 100)
            ]
        }
        func save(_ transaction: Transaction) throws {}
        func delete(_ transaction: Transaction) throws {}
    }
    
    private class HTTPClientSpy: HTTPClient {
        var putRequestsCallCount = 0
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
            return ClientTask()
        }
        
        func put(_ data: Data, to url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
            putRequestsCallCount += 1
            return ClientTask()
        }
        
        private class ClientTask: HTTPClientTask {
            func cancel() {}
        }
    }
}
