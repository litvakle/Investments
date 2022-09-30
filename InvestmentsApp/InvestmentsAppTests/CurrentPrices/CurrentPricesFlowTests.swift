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
    func test_transactionsUpdate_leadsToUpdateCurrentPricesOnlyForNewTickets() {
        let (sut, transactionsViewModel, currentPricesViewModel, currentPriceLoader) = makeSUT(transactions: [])
        sut.setupSubscriptions(currentPricesViewModel: currentPricesViewModel, transactionsViewModel: transactionsViewModel)
        let expectedPrices: CurrentPrices = [
            "BBB": CurrentPrice(price: 200),
            "AAA": CurrentPrice(price: 100),
            "CCC": CurrentPrice(price: 300)
        ]
        
        XCTAssertTrue(currentPricesViewModel.currentPrices.isEmpty)
        makePortfolioTransactions().forEach { transactionsViewModel.save($0) }
        XCTAssertEqual(currentPriceLoader.loadFeedCallCount, 3)
        
        currentPriceLoader.completeCurrentPriceLoading(with: CurrentPrice(price: 200), at: 0)
        currentPriceLoader.completeCurrentPriceLoading(with: CurrentPrice(price: 100), at: 1)
        currentPriceLoader.completeCurrentPriceLoading(with: CurrentPrice(price: 300), at: 2)
        
        XCTAssertEqual(currentPricesViewModel.currentPrices, expectedPrices)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        transactions: [Transaction],
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (CurrentPricesFlow, TransactionsViewModel, CurrentPricesViewModel, LoaderSpy) {
        let store = InMemoryTransactionsStore()
        store.transactions = transactions
        let transactionsViewModel = TransactionsViewModel(store: store)
        transactionsViewModel.retrieve()
        let currentPriceLoader = LoaderSpy()
        let currentPricesViewModel = CurrentPricesViewModel(loader: currentPriceLoader.loadPublisher)
        let sut = CurrentPricesFlow()
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(transactionsViewModel, file: file, line: line)
        trackForMemoryLeaks(currentPriceLoader, file: file, line: line)
        trackForMemoryLeaks(currentPricesViewModel, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, transactionsViewModel, currentPricesViewModel, currentPriceLoader)
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
        
        func completeCurrentPriceLoadingWithError(at index: Int = 0) {
            requests[index].send(completion: .failure(anyNSError()))
        }
        
        func completeCurrentPriceLoading(with currentPrice: CurrentPrice, at index: Int = 0) {
            requests[index].send(currentPrice)
            requests[index].send(completion: .finished)
        }
    }
}
