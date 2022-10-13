//
//  APIEndToEndTests.swift
//  APIEndToEndTests
//
//  Created by Lev Litvak on 28.09.2022.
//

import XCTest
import InvestmentsFrameworks

class APIEndToEndTests: XCTestCase {
    func test_endToEndServerGETCurrentPricesResult_deliversSuccessfully() {
        switch getResult(url: currentPricesTestServerURL, mapper: CurrentPriceMapper.map) {
        case let .success(currentPrice)?:
            XCTAssertTrue(currentPrice.price > 0)
            
        case let .failure(error)?:
            XCTFail("Expected successful result, got \(error) instead")
            
        default:
            XCTFail("Expected successful result, got no result instead")
        }
    }
    
    func test_endToEndServerGETTransactionsResult_deliversSuccessfully() {
        switch getResult(url: transactionsTestServerURL, mapper: TransactionsMapper.map) {
        case let .success(receivedTransactions)?:
            XCTAssertEqual(receivedTransactions, makeTransactions())
            
        case let .failure(error)?:
            XCTFail("Expected successful result, got \(error) instead")
            
        default:
            XCTFail("Expected successful result, got no result instead")
        }
    }
    
    func test_endToEndServerPUTTransactionsResult_deliversSuccessfully() {
        let transactions = makeTransactions()
        let data = TransactionsMapper.map(transactions)!
        
        switch putResult(for: transactions, url: transactionsTestServerURL, data: data, mapper: TransactionsMapper.map) {
        case let .success(uploadedTransactions)?:
            XCTAssertEqual(uploadedTransactions, transactions)
            
        case let .failure(error)?:
            XCTFail("Expected successful result, got \(error) instead")
            
        default:
            XCTFail("Expected successful result, got no result instead")
        }
    }
    
    // MARK: - Helpers
    
    private func makeTransactions() -> [Transaction] {
        [
            Transaction(id: UUID(uuidString: "1870AAF2-1DF7-4114-B845-BAFB0B0E4138")!, date: Date(timeIntervalSince1970: 1598627222), ticket: "AAA", type: .buy, quantity: 10, price: 2, sum: 20),
            Transaction(id: UUID(uuidString: "3F9EE62C-90E9-4EFB-847F-A9ED0443FA97")!, date: Date(timeIntervalSince1970: 1577881882), ticket: "BBB", type: .sell, quantity: 5, price: 20, sum: 100)
        ]
    }
    
    private func getResult<T>(
        file: StaticString = #filePath,
        line: UInt = #line,
        url: URL,
        mapper: @escaping (Data, HTTPURLResponse) throws -> T
    ) -> Swift.Result<T, Error>? {
        let client = ephemeralClient()
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: Swift.Result<T, Error>?
        client.get(from: url) { [weak self] result in
            receivedResult = self?.map(result, with: mapper)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 15.0)
        
        return receivedResult
    }
    
    private func putResult<T>(
        file: StaticString = #filePath,
        line: UInt = #line,
        for transactions: [Transaction],
        url: URL,
        data: Data,
        mapper: @escaping (Data, HTTPURLResponse) throws -> T
    ) -> Swift.Result<T, Error>? {
        let client = ephemeralClient()
        let exp = expectation(description: "Wait for upload completion")

        var receivedResult: Swift.Result<T, Error>?
        client.put(data, to: url) { [weak self] result in
            receivedResult = self?.map(result, with: mapper)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 15.0)
        
        return receivedResult
    }
    
    private func map<T>(
        _ result: HTTPClient.Result,
        with mapper: (Data, HTTPURLResponse) throws -> T
    ) -> Result<T, Error> {
        result.flatMap { (data, response) in
            do {
                return .success(try mapper(data, response))
            } catch {
                return .failure(error)
            }
        }
    }
    
    private func ephemeralClient(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        trackForMemoryLeaks(client, file: file, line: line)
        return client
    }
    
    private var currentPricesTestServerURL: URL {
        return URL(string: "https://finnhub.io/api/v1/quote?symbol=AAPL&token=ccfe31iad3ifmhk0t53g")!
    }
    
    private var transactionsTestServerURL: URL {
        return URL(string: "https://investments-3b67e-default-rtdb.firebaseio.com/transactionsTest.json")!
    }
}
