//
//  CurrentPricesFlowTests.swift
//  InvestmentsWatchOS WatchKit ExtensionTests
//
//  Created by Lev Litvak on 18.10.2022.
//

import XCTest
import Combine
import InvestmentsFrameworksWatchOS
@testable import InvestmentsWatchOS_WatchKit_Extension

class CurrentPricesFlowTests: XCTestCase {
    func test_transactionsUpdate_leadsToInvokeLoadingCurrentPrices() {
        let (sut, transactionsViewModel, currentPricesViewModel, currentPriceLoader, _) = makeSUT()
        sut.setupSubscriptions(transactionsViewModel: transactionsViewModel, currentPricesViewModel: currentPricesViewModel)

        transactionsViewModel.retrieve()
        currentPriceLoader.completeCurrentPriceLoading(with: CurrentPrice(price: 10), at: 0)
        currentPriceLoader.completeCurrentPriceLoading(with: CurrentPrice(price: 20), at: 1)
        
        XCTAssertEqual(currentPriceLoader.ticketsToLoadCurrentPrices, ["AAA", "BBB"])
    }
    
    func test_currentPricesFlow_activatesErrorMessageOnlyOnError() {
        let (sut, _, currentPricesViewModel, _, alertViewModel) = makeSUT()
        sut.setupSubscriptions(currentPricesViewModel: currentPricesViewModel, alertViewModel: alertViewModel)

        currentPricesViewModel.error = nil
        XCTAssertFalse(alertViewModel.isActive)
        
        currentPricesViewModel.error = "Any error"
        XCTAssertTrue(alertViewModel.isActive)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        store: InMemoryStore = .withStoreData,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (CurrentPricesFlow, TransactionsViewModel, CurrentPricesViewModel, CurrentPriceLoaderSpy, AlertViewModel) {
        let transactionsViewModel = TransactionsViewModel(retriever: store.retrivePublisher, saver: .none, deleter: .none)
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
