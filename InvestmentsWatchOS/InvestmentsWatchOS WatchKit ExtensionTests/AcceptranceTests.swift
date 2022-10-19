//
//  AcceptranceTests.swift
//  InvestmentsWatchOS WatchKit ExtensionTests
//
//  Created by Lev Litvak on 18.10.2022.
//

import XCTest
import Combine
import InvestmentsFrameworksWatchOS
@testable import InvestmentsWatchOS_WatchKit_Extension

class AcceptanceTests: XCTestCase {
    func test_onLaunch_loadsTransactionsAndCurrentPricesForUserWithInternetConnection() {
        let sut = makeSUT(httpClient: .online(response))
        let expectedTransactions = makeTransactions().model
        let expectedCurrentPrices: CurrentPrices = [
            "AAA": CurrentPrice(price: 100),
            "BBB": CurrentPrice(price: 200)
        ]
        
        XCTAssertEqual(sut.transactionsViewModel.transactions, expectedTransactions)
        XCTAssertEqual(sut.currentPricesViewModel.currentPrices, expectedCurrentPrices)
        XCTAssertTrue(sut.portfolioViewModel.summary.cost != 0)
        XCTAssertTrue(sut.portfolioViewModel.summary.profit != 0)
        XCTAssertTrue(sut.portfolioViewModel.summary.profitPercent != 0)
    }
    
    func test_onLoadError_displaysErrorMessageForUserWithoutInternetConnection() {
        let sut = makeSUT(httpClient: .offline)
        
        XCTAssertTrue(sut.alertViewModel.isActive)
    }
    
    // MARK: - Helpers
    
    func makeSUT(
        httpClient: HTTPClientStub,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> ContentView {
        let root = UIComposer(
            httpClient: httpClient,
            currentPricesBaseURL: URL(string: "http://base-url.com")!,
            currentPricesToken: "token",
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
            
        case "/transactions.json":
            return makeTransactions().data
        default:
            return Data()
        }
    }
    
    private func makeTransactions() -> (data: Data, model: [Transaction]) {
        let item1 = makeItem(
            id: UUID(uuidString: "2AB2AE66-A4B7-4A16-B374-51BBAC8DB086")!,
            date: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"),
            ticket: "AAA",
            type: .buy,
            quantity: 10,
            price: 20,
            sum: 200
        )
    
        let item2 = makeItem(
            id: UUID(uuidString: "A28F5FE3-27A7-44E9-8DF5-53742D0E4A5A")!,
            date: (Date(timeIntervalSince1970: 1577881882), "2020-01-01T12:31:22+00:00"),
            ticket: "BBB",
            type: .buy,
            quantity: 5,
            price: 10,
            sum: 50
        )
        
        let data = makeJSON([item1.json, item2.json])
        let models = [item1.model, item2.model]
        
        return (data, models)
    }
    
    func makeJSON(_ data: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: data)
    }
    
    private func makeItem(id: UUID, date: (date: Date, iso8601String: String), ticket: String, type: TransactionType, quantity: Double, price: Double, sum: Double) -> (model: Transaction, json: [String: Any]) {
        let item = Transaction(id: id, date: date.date, ticket: ticket, type: type, quantity: quantity, price: price, sum: sum)
        
        let json: [String: Any] = [
            "id": id.uuidString,
            "date": date.iso8601String,
            "ticket": ticket,
            "type": type.asString(),
            "quantity": quantity,
            "price": price,
            "sum": sum
        ]
        
        return (item, json)
    }
}
