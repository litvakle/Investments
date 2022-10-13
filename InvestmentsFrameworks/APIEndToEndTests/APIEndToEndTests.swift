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
        case let .success(transactions)?:
            XCTAssertTrue(transactions.count > 0)
            
        case let .failure(error)?:
            XCTFail("Expected successful result, got \(error) instead")
            
        default:
            XCTFail("Expected successful result, got no result instead")
        }
    }
    
    func test_endToEndServerPUTTransactionsResult_deliversSuccessfully() {
        let transactions = [
            Transaction(id: UUID(), date: Date(timeIntervalSince1970: 1598627222), ticket: "AAA", type: .buy, quantity: 10, price: 2, sum: 20),
            Transaction(id: UUID(), date: Date(timeIntervalSince1970: 1577881882), ticket: "BBB", type: .sell, quantity: 5, price: 20, sum: 100)
        ]
        
        switch putResult(for: transactions, url: transactionsTestServerURL, encoder: TransactionsMapper.map,  decoder: TransactionsMapper.map) {
        case let .success(uploadedTransactions)?:
            XCTAssertEqual(uploadedTransactions, transactions)
            
        case let .failure(error)?:
            XCTFail("Expected successful result, got \(error) instead")
            
        default:
            XCTFail("Expected successful result, got no result instead")
        }
    }
    
    // MARK: - Helpers
    
    private func getResult<T>(
        file: StaticString = #filePath,
        line: UInt = #line,
        url: URL,
        mapper: @escaping (Data, HTTPURLResponse) throws -> T
    ) -> Swift.Result<T, Error>? {
        let client = ephemeralClient()
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: Swift.Result<T, Error>?
        client.get(from: url) { result in
            receivedResult = result.flatMap { (data, response) in
                do {
                    return .success(try mapper(data, response))
                } catch {
                    return .failure(error)
                }
            }
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
        encoder: @escaping ([Transaction]) -> Data?,
        decoder: @escaping (Data, HTTPURLResponse) throws -> T
    ) -> Swift.Result<T, Error>? {
        let client = ephemeralClient()
        let data = encoder(transactions)!
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: Swift.Result<T, Error>?
        client.put(data, to: url) { result in
            receivedResult = result.flatMap { (data, response) in
                do {
                    return .success(try decoder(data, response))
                } catch {
                    return .failure(error)
                }
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 15.0)
        
        return receivedResult
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
