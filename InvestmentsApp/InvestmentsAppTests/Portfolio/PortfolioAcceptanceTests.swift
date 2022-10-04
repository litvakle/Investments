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

class PortfolioAcceptanceTests: XCTestCase {
    func test_portfolio_rendersAccordingToTransactions() throws {
        let (sut, transactionsViewModel) = makeSUT()
        try sut.callOnAppear()

        XCTAssertEqual(try sut.portfolioView().items().count, 0, "Expected empty list for empty store")
        
        makePortfolioTransactions().forEach { transactionsViewModel.save($0) }
        XCTAssertEqual(try sut.portfolioView().items().count, 3, "Expected non-empty list for non-empty store")
        
        transactionsViewModel.save(Transaction(ticket: "DDD", quantity: 10, price: 20, sum: 200))
        XCTAssertEqual(try sut.portfolioView().items().count, 4, "Expected updated list including ticket for new transaction")
    }
    
    func test_portfolio_rendersItemsForStoredTransactions() throws {
        let (sut, _) = makeSUT(store: .withStoredData)
        
        try sut.callOnAppear()

        XCTAssertEqual(try sut.portfolioView().items().count, 3)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        store: InMemoryStore = .empty,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (ContentView, TransactionsViewModel) {
        let transactionsViewModel = TransactionsViewModelFactory.createViewModel(store: store)
        let alertViewModel = AlertViewModel()
        let transactionsFlow = TransactionsFlow()
        let portfolioViewModel = PortfolioViewModel()
        let portfolioFlow = PortfolioFlow()
        let currentPricesFlow = CurrentPricesFlow()
        let currentPriceLoader = CurrentPriceLoaderSpy()
        let sut = ContentView(
            transactionsViewModel: transactionsViewModel,
            portfolioViewModel: portfolioViewModel,
            currentPricesViewModel: CurrentPricesViewModel(loader: currentPriceLoader.loadPublisher),
            alertViewModel: alertViewModel,
            transactionsFlow: transactionsFlow,
            portfolioFlow: portfolioFlow,
            currentPricesFlow: currentPricesFlow
        )
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(portfolioViewModel, file: file, line: line)
        trackForMemoryLeaks(transactionsViewModel, file: file, line: line)
        trackForMemoryLeaks(alertViewModel, file: file, line: line)
        trackForMemoryLeaks(transactionsFlow, file: file, line: line)
        trackForMemoryLeaks(portfolioFlow, file: file, line: line)
        trackForMemoryLeaks(currentPricesFlow, file: file, line: line)
        
        return (sut, transactionsViewModel)
    }
}

extension ContentView {
    func portfolioView() throws -> PortfolioView {
        try self.inspect().find(PortfolioView.self).actualView()
    }
    
    func callOnAppear() throws {
        try self.inspect().find(viewWithAccessibilityIdentifier: "MAIN_TAB_VIEW").tabView().callOnAppear()
    }
}
