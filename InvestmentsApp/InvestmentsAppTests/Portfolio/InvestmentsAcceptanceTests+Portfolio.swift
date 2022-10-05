//
//  PortfolioAcceptanceTests.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 27.09.2022.
//

import XCTest
import Combine
import InvestmentsFrameworks
import ViewInspector
@testable import InvestmentsApp

extension InvestmentsAcceptranceTests {
    func test_portfolio_rendersAccordingToTransactions() throws {
        let sut = makeSUT(httpClient: .offline, store: .empty)

        XCTAssertEqual(try sut.portfolioView().items().count, 0, "Expected empty list for empty store")
        
        makePortfolioTransactions().forEach { sut.transactionsViewModel.save($0) }
        XCTAssertEqual(try sut.portfolioView().items().count, 3, "Expected non-empty list for non-empty store")
        
        sut.transactionsViewModel.save(Transaction(ticket: "DDD", quantity: 10, price: 20, sum: 200))
        XCTAssertEqual(try sut.portfolioView().items().count, 4, "Expected updated list including ticket for new transaction")
    }
    
    func test_portfolio_rendersItemsForStoredTransactions() throws {
        let sut = makeSUT(httpClient: .offline, store: .withStoredData)
        
        XCTAssertEqual(try sut.portfolioView().items().count, 3)
    }
}

extension ContentView {
    func portfolioView() throws -> PortfolioView {
        try self.inspect().find(PortfolioView.self).actualView()
    }
}
