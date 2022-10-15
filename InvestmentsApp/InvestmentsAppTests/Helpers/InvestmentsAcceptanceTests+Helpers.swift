//
//  InvestmentsAcceptanceTests+Helpers.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 05.10.2022.
//

import Foundation
import XCTest
import InvestmentsFrameworks
@testable import InvestmentsApp

class InvestmentsAcceptranceTests: XCTestCase {}

extension InvestmentsAcceptranceTests {
    func makeSUT(
        httpClient: HTTPClientStub,
        store: InMemoryStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> ContentView {
        let root = UIComposer(
            httpClient: httpClient,
            transactionsStore: store,
            currentPricesStore: store,
            baseURL: URL(string: "http://base-url.com")!,
            token: "token",
            transactionsProjectID: "A project ID"
        )
        
        let sut = ContentView(
            transactionsViewModel: root.transactionsViewModel,
            portfolioViewModel: root.portfolioViewModel,
            currentPricesViewModel: root.currentPricesViewModel,
            alertViewModel: root.alertViewModel,
            transactionsFlow: root.transactionsFlow,
            portfolioFlow: root.portfolioFlow,
            currentPricesFlow: root.currentPricesFlow
        )
        
        trackForMemoryLeaks(root.transactionsViewModel, file: file, line: line)
        trackForMemoryLeaks(root.portfolioViewModel, file: file, line: line)
        trackForMemoryLeaks(root.currentPricesViewModel, file: file, line: line)
        trackForMemoryLeaks(root.alertViewModel, file: file, line: line)
        trackForMemoryLeaks(root.transactionsFlow, file: file, line: line)
        trackForMemoryLeaks(root.portfolioFlow, file: file, line: line)
        trackForMemoryLeaks(root.currentPricesFlow, file: file, line: line)
        
        return sut
    }

    func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }

    private func makeData(for url: URL) -> Data {
        switch url.path {
        case "/v1/quote" where url.query?.contains("AAA") == true:
            return try! JSONSerialization.data(withJSONObject: ["c": 100])
            
        case "/v1/quote" where url.query?.contains("BBB") == true:
            return try! JSONSerialization.data(withJSONObject: ["c": 200])
            
        case "/v1/quote" where url.query?.contains("CCC") == true:
            return try! JSONSerialization.data(withJSONObject: ["c": 300])
            
        case "/v1/quote" where url.query?.contains("DDD") == true:
            return try! JSONSerialization.data(withJSONObject: ["c": 400])
            
        default:
            return Data()
        }
    }
}
