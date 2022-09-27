//
//  PortfolioAcceptanceTests.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 27.09.2022.
//

import XCTest
import InvestmentsFrameworks
import ViewInspector
@testable import InvestmentsApp

class PortfolioAcceptanceTests: XCTestCase {
    func test_onLaunch_rendersPortfolioForStoredTransactions() throws {
        let (sut, transactionsViewModel) = makeSUT(transactions: makePortfolioTransactions())
        
        try sut.callOnAppear()
        transactionsViewModel.retrieve()
        
        XCTAssertEqual(try sut.portfolioView().items().count, 2)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        transactions: [Transaction],
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (ContentView, TransactionsViewModel) {
        let store = InMemoryTransactionsStore()
        store.transactions = transactions
        let transactionsViewModel = TransactionsViewModelFactory.createViewModel(store: store)
        let alertViewModel = AlertViewModel()
        let mainFlow = MainFlow()
        let portfolioViewModel = PortfolioViewModel()
        let portfolioFlow = PortfolioFlow()
        let sut = ContentView(
            transactionsViewModel: transactionsViewModel,
            portfolioViewModel: portfolioViewModel,
            alertViewModel: alertViewModel,
            mainFlow: mainFlow,
            portfolioFlow: portfolioFlow
        )
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(portfolioViewModel, file: file, line: line)
        trackForMemoryLeaks(transactionsViewModel, file: file, line: line)
        trackForMemoryLeaks(alertViewModel, file: file, line: line)
        trackForMemoryLeaks(mainFlow, file: file, line: line)
        trackForMemoryLeaks(portfolioFlow, file: file, line: line)
        
        return (sut, transactionsViewModel)
    }
}

private extension ContentView {
    func portfolioView() throws -> PortfolioView {
        try self.inspect().find(PortfolioView.self).actualView()
    }
    
    func portfolioViewCount() throws -> Int {
        try self.inspect().find(PortfolioView.self).find(ViewType.ForEach.self).count
    }
    
    func callOnAppear() throws {
        try self.inspect().find(viewWithAccessibilityIdentifier: "MAIN_TAB_VIEW").tabView().callOnAppear()
    }
}
