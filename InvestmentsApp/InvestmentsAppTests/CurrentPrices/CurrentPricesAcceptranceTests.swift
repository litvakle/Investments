//
//  CurrentPricesAcceptranceTests.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 30.09.2022.
//

import XCTest
import Combine
import InvestmentsFrameworks
@testable import InvestmentsApp
@testable import ViewInspector

class CurrentPricesAcceptranceTests: XCTestCase {
    func test_refreshPortfolio_leadsToRefreshCurrentPricesForAllTickets() throws {
        let (sut, _, currentPricesViewModel, currentPriceLoader, _) = makeSUT(transactions: [])
        try sut.callOnAppear()
        currentPricesViewModel.currentPrices = makeCurrentPrices()
        let portfolioView = try sut.portfolioView()
        
        portfolioView.onRefresh()
        
        XCTAssertEqual(currentPriceLoader.requests.count, 2)
    }
    
    func test_saveTransactionWithNewTicket_leadsToLoadCurrentPriceForTheTicket() throws {
        let (sut, transactionsVewModel, currentPricesViewModel, currentPriceLoader, _) = makeSUT(transactions: [])
        try sut.callOnAppear()
        currentPricesViewModel.currentPrices = makeCurrentPrices()

        transactionsVewModel.save(Transaction(ticket: "AAA"))
        transactionsVewModel.save(Transaction(ticket: "DDD"))
        
        XCTAssertEqual(currentPriceLoader.requests.count, 1)
    }
    
    func test_currentPriceLoadError_leadsToActivateErrorMessage() throws {
        let (sut, _, currentPricesViewModel, _, alertViewModel) = makeSUT(transactions: [])
        try sut.callOnAppear()
        
        currentPricesViewModel.error = "Any error"
        
        XCTAssertTrue(alertViewModel.isActive)
    }
    
    private func makeSUT(
        transactions: [Transaction],
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (ContentView, TransactionsViewModel, CurrentPricesViewModel, CurrentPriceLoaderSpy, AlertViewModel) {
        let store = InMemoryTransactionsStore()
        store.transactions = transactions
        let transactionsViewModel = TransactionsViewModelFactory.createViewModel(store: store)
        let alertViewModel = AlertViewModel()
        let mainFlow = MainFlow()
        let portfolioViewModel = PortfolioViewModel()
        let portfolioFlow = PortfolioFlow()
        let currentPriceLoader = CurrentPriceLoaderSpy()
        let currentPricesViewModel = CurrentPricesViewModel(loader: currentPriceLoader.loadPublisher)
        let currentPricesFlow = CurrentPricesFlow()
        let sut = ContentView(
            transactionsViewModel: transactionsViewModel,
            portfolioViewModel: portfolioViewModel,
            currentPricesViewModel: currentPricesViewModel,
            alertViewModel: alertViewModel,
            mainFlow: mainFlow,
            portfolioFlow: portfolioFlow,
            currentPricesFlow: currentPricesFlow
        )
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(portfolioViewModel, file: file, line: line)
        trackForMemoryLeaks(transactionsViewModel, file: file, line: line)
        trackForMemoryLeaks(alertViewModel, file: file, line: line)
        trackForMemoryLeaks(mainFlow, file: file, line: line)
        trackForMemoryLeaks(portfolioFlow, file: file, line: line)
        
        return (sut, transactionsViewModel, currentPricesViewModel, currentPriceLoader, alertViewModel)
    }
}
