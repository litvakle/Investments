//
//  PortfolioFlowTests.swift
//  InvestmentsWatchOS WatchKit ExtensionTests
//
//  Created by Lev Litvak on 18.10.2022.
//

import XCTest
import Combine
import InvestmentsFrameworks
@testable import InvestmentsWatchOS_WatchKit_Extension

class PortfolioFlowTests: XCTestCase {
    func test_portfolioFlow_updatesPortfolioOnTransactionsAndCurrentPricesUpdate() {
        let (sut, transactionsViewModel, portfolioViewModel, currentPricesViewModel) = makeSUT(store: .withStoreData)
        sut.setupSubscriptions(portfolioViewModel: portfolioViewModel, transactionsViewModel: transactionsViewModel, currentPricesViewModel: currentPricesViewModel)
        
        transactionsViewModel.retrieve()
        currentPricesViewModel.currentPrices = [
            "AAA": CurrentPrice(price: 100),
            "BBB": CurrentPrice(price: 200)
        ]
        
        XCTAssertTrue(portfolioViewModel.summary.cost != 0)
        XCTAssertTrue(portfolioViewModel.summary.profit != 0)
        XCTAssertTrue(portfolioViewModel.summary.profitPercent != 0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        store: InMemoryStore = .withStoreData,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (PortfolioFlow, TransactionsViewModel, PortfolioViewModel, CurrentPricesViewModel) {
        let transactionsViewModel = TransactionsViewModel(retriever: store.retrivePublisher, saver: store.savePublisher, deleter: store.deletePublisher)
        transactionsViewModel.retrieve()
        let portfolioViewModel = PortfolioViewModel()
        let currentPriceLoader = CurrentPriceLoaderSpy()
        let currentPricesViewModel = CurrentPricesViewModel(loader: currentPriceLoader.loadPublisher)
        let sut = PortfolioFlow()
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(transactionsViewModel, file: file, line: line)
        trackForMemoryLeaks(portfolioViewModel, file: file, line: line)
        trackForMemoryLeaks(currentPricesViewModel, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, transactionsViewModel, portfolioViewModel, currentPricesViewModel)
    }
}
