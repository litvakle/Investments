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
    
    func test_retrieve_requestsStore() {
        let (sut, store) = makeSUT()
        
        _ = try? sut.retrieve()
        _ = try? sut.retrieve()
        
        XCTAssertEqual(store.requests, [.retrieve, .retrieve])
    }
    
    func test_retrieve_deliversRetrivalErrorOnRetrivalFailure() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteRetrivalWith: .failure(TransactionsStorage.RetrivalError.failed), when: {
            store.completeRetrival(withError: anyNSError())
        })
    }
    
    // MARK: - Herlpers
    
    private func makeSUT() -> (TransactionsStorage, StoreSpy) {
        let store = StoreSpy()
        let storage = TransactionsStorage(store: store)
        
        return (storage, store)
    }
    
    private func expect(_ sut: TransactionsStorage, toCompleteRetrivalWith expectedResult: Result<[Transaction], Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        action()
        
        let receivedResult = Result { try sut.retrieve() }
        
        switch (receivedResult, expectedResult) {
        case let (.success(receivedTransactions), .success(expectedTransactions)):
            XCTAssertEqual(receivedTransactions, expectedTransactions, file: file, line: line)
            
        case (.failure(let receivedError as TransactionsStorage.RetrivalError),
              .failure(let expectedError as TransactionsStorage.RetrivalError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
    
    private class StoreSpy: TransactionsStore {
        private(set) var requests = [Request]()
        private var retrivalResult: Result<[Transaction], Error>?
        
        enum Request: Equatable {
            case retrieve
        }
        
        func retrieve() throws -> [Transaction]? {
            requests.append(.retrieve)
            return try retrivalResult?.get()
        }
        
        func completeRetrival(withError error: Error) {
            retrivalResult = .failure(error)
        }
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
}
