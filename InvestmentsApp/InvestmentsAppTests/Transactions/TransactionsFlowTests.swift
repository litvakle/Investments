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
        let (sut, transactionsViewModel, alertViewModel, _) = makeSUT(store: InMemoryStore.withStoredData)
        
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
        let (sut, transactionsViewModel, _, httpClient) = makeSUT(store: InMemoryStore.withStoredData)
        
        sut.setupSubscriptions(
            transactionsViewModel: transactionsViewModel,
            httpClient: httpClient,
            url: URL(string: "http://any-url.com")!
        )
        
        XCTAssertEqual(httpClient.putRequestsCallCount, 1)
    }
    
    func test_transactionsFlow_DoesNotMakePutRequestOnNoStoredTransactions() {
        let (sut, transactionsViewModel, _, httpClient) = makeSUT(store: InMemoryStore.empty)
        
        sut.setupSubscriptions(
            transactionsViewModel: transactionsViewModel,
            httpClient: httpClient,
            url: URL(string: "http://any-url.com")!
        )
        
        XCTAssertEqual(httpClient.putRequestsCallCount, 0)
    }
    
    func test_transactionsFlow_DoesNotMakeDuplicatePutRequests() {
        let (sut, transactionsViewModel, _, httpClient) = makeSUT(store: InMemoryStore.withStoredData)
        sut.setupSubscriptions(
            transactionsViewModel: transactionsViewModel,
            httpClient: httpClient,
            url: URL(string: "http://any-url.com")!
        )
        let transaction = Transaction(ticket: "ZZZ")
        transactionsViewModel.save(transaction)
        let count = httpClient.putRequestsCallCount
        
        transactionsViewModel.save(transaction)
        
        XCTAssertEqual(httpClient.putRequestsCallCount, count)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        store: InMemoryStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (TransactionsFlow, TransactionsViewModel, AlertViewModel, HTTPClientSpy) {
        let transactionsViewModel = TransactionsViewModel(store: store)
        let sut = TransactionsFlow()
        let httpClient = HTTPClientSpy()
        let alertViewModel = AlertViewModel()
        
        transactionsViewModel.retrieve()
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(transactionsViewModel, file: file, line: line)
        trackForMemoryLeaks(alertViewModel, file: file, line: line)
        trackForMemoryLeaks(httpClient, file: file, line: line)
        
        return (sut, transactionsViewModel, alertViewModel, httpClient)
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
