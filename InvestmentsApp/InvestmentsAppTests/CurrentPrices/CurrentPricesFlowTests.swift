//
//  CurrentPricesFlowTests.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 30.09.2022.
//

import XCTest
import Combine
import InvestmentsFrameworks
@testable import InvestmentsApp

class CurrentPricesFlowTests: XCTestCase {
    func test_transactionsUpdate_leadsToUpdateCurrentPricesOnlyForTicketsWithoutPrices() {
        let (sut, transactionsViewModel, currentPricesViewModel, currentPriceLoader, alertViewModel) = makeSUT(transactions: [])
        sut.setupSubscriptions(currentPricesViewModel: currentPricesViewModel, transactionsViewModel: transactionsViewModel, alertViewModel: alertViewModel)
        currentPricesViewModel.currentPrices = [
            "AAA": CurrentPrice(price: 100),
            "BBB": CurrentPrice(price: 200)
        ]
        
        makePortfolioTransactions().forEach { transactionsViewModel.save($0) }
        XCTAssertEqual(currentPriceLoader.loadFeedCallCount, 1, "Expected only one load for 'CCC' ticket")
    }
    
    func test_currentPricesError_activatesErrorMessage() throws {
        let (sut, transactionsViewModel, currentPricesViewModel, _, alertViewModel) = makeSUT(transactions: [])
        sut.setupSubscriptions(currentPricesViewModel: currentPricesViewModel, transactionsViewModel: transactionsViewModel, alertViewModel: alertViewModel)
        
        currentPricesViewModel.error = "Any error"
       
        XCTAssertTrue(alertViewModel.isActive)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        transactions: [Transaction],
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (CurrentPricesFlow, TransactionsViewModel, CurrentPricesViewModel, CurrentPriceLoaderSpy, AlertViewModel) {
        let store = InMemoryTransactionsStore()
        store.transactions = transactions
        let transactionsViewModel = TransactionsViewModel(store: store)
        transactionsViewModel.retrieve()
        let currentPriceLoader = CurrentPriceLoaderSpy()
        let currentPricesViewModel = CurrentPricesViewModel(loader: currentPriceLoader.loadPublisher)
        let alertViewModel = AlertViewModel()
        let sut = CurrentPricesFlow()
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(transactionsViewModel, file: file, line: line)
        trackForMemoryLeaks(currentPriceLoader, file: file, line: line)
        trackForMemoryLeaks(currentPricesViewModel, file: file, line: line)
        trackForMemoryLeaks(alertViewModel, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, transactionsViewModel, currentPricesViewModel, currentPriceLoader, alertViewModel)
    }
}
