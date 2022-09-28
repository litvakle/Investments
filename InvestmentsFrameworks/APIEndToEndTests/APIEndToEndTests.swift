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
        switch getCurrentPricesResult() {
        case let .success(currentPrice)?:
            XCTAssertTrue(currentPrice.price > 0)
            
        case let .failure(error)?:
            XCTFail("Expected successful feed result, got \(error) instead")
            
        default:
            XCTFail("Expected successful feed result, got no result instead")
        }
    }
    
    // MARK: - Helpers
    
    private func getCurrentPricesResult(file: StaticString = #filePath, line: UInt = #line) -> Swift.Result<CurrentPrice, Error>? {
        let client = ephemeralClient()
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: Swift.Result<CurrentPrice, Error>?
        client.get(from: currentPricesTestServerURL) { result in
            receivedResult = result.flatMap { (data, response) in
                do {
                    return .success(try CurrentPriceMapper.map(data, from: response))
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
}
