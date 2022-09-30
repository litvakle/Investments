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

class CurrentPricesAcceptranceTests: XCTestCase {
    func test_refreshPortfolio_leadsToRefreshCurrentPricesForAllTickets() throws {
        let (sut, currentPricesViewModel, currentPriceLoader) = makeSUT(transactions: [])
        try sut.callOnAppear()
        currentPricesViewModel.currentPrices = [
            "AAA": CurrentPrice(price: 100),
            "BBB": CurrentPrice(price: 200),
            "CCC": CurrentPrice(price: 300)
        ]
        let portfolioView = try sut.portfolioView()
        
        portfolioView.onRefresh()
        
        XCTAssertEqual(currentPriceLoader.requests.count, 3)
    }
    
    private func makeSUT(
        transactions: [Transaction],
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (ContentView, CurrentPricesViewModel, LoaderSpy) {
        let store = InMemoryTransactionsStore()
        store.transactions = transactions
        let transactionsViewModel = TransactionsViewModelFactory.createViewModel(store: store)
        let alertViewModel = AlertViewModel()
        let mainFlow = MainFlow()
        let portfolioViewModel = PortfolioViewModel()
        let portfolioFlow = PortfolioFlow()
        let currentPriceLoader = LoaderSpy()
        let currentPricesViewModel = CurrentPricesViewModel(loader: currentPriceLoader.loadPublisher)
        let sut = ContentView(
            transactionsViewModel: transactionsViewModel,
            portfolioViewModel: portfolioViewModel,
            currentPricesViewModel: currentPricesViewModel,
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
        
        return (sut, currentPricesViewModel, currentPriceLoader)
    }
    
    private class LoaderSpy {
        var requests = [PassthroughSubject<CurrentPrice, Error>]()
        
        var loadFeedCallCount: Int {
            return requests.count
        }
        
        func loadPublisher() -> AnyPublisher<CurrentPrice, Error> {
            let publisher = PassthroughSubject<CurrentPrice, Error>()
            requests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
    }
}
