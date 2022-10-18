//
//  PortfolioFlowTests.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 27.09.2022.
//

import XCTest
import InvestmentsFrameworks
import Combine
@testable import InvestmentsApp

class PortfolioFlowTests: XCTestCase {
    func test_saveTransaction_leadsToUpdatePortfolio() {
        let (sut, transactionsViewModel, portfolioViewModel, currentPricesViewModel) = makeSUT(store: .empty)
        
        sut.setupSubscriptions(portfolioViewModel: portfolioViewModel, transactionsViewModel: transactionsViewModel, currentPricesViewModel: currentPricesViewModel)
        currentPricesViewModel.currentPrices = makeCurrentPrices()
        
        XCTAssertEqual(portfolioViewModel.items, [])
        makePortfolioTransactions().forEach { transactionsViewModel.save($0) }
        XCTAssertEqual(portfolioViewModel.items, makePortfolioItems())
    }
    
    func test_initWithStoredTransactions_createsPotrfolioItems() {
        let (sut, transactionsViewModel, portfolioViewModel, currentPricesViewModel) = makeSUT()
        
        sut.setupSubscriptions(portfolioViewModel: portfolioViewModel, transactionsViewModel: transactionsViewModel, currentPricesViewModel: currentPricesViewModel)
        currentPricesViewModel.currentPrices = makeCurrentPrices()
        
        XCTAssertEqual(portfolioViewModel.items, makePortfolioItems())
    }
    
    func test_currentPricesUpdate_leadsToUpdatePortfolio() {
        let (sut, transactionsViewModel, portfolioViewModel, currentPricesViewModel) = makeSUT()
        
        sut.setupSubscriptions(portfolioViewModel: portfolioViewModel, transactionsViewModel: transactionsViewModel, currentPricesViewModel: currentPricesViewModel)
        currentPricesViewModel.currentPrices = makeCurrentPrices()
        currentPricesViewModel.currentPrices["AAA"] = CurrentPrice(price: 5)
        
        XCTAssertNotEqual(portfolioViewModel.items, makePortfolioItems())
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        store: InMemoryStore = .withStoredData,
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
