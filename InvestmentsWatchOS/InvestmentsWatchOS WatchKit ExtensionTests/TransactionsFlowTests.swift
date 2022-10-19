//
//  TransactionsFlowTests.swift
//  InvestmentsWatchOS WatchKit ExtensionTests
//
//  Created by Lev Litvak on 18.10.2022.
//

import XCTest
import InvestmentsFrameworks
@testable import InvestmentsWatchOS_WatchKit_Extension

class TransactionsFlowTests: XCTestCase {
    func test_transactionsFlow_activatesErrorMessageOnlyOnError() {
        let (sut, transactionsViewModel, alertViewModel) = makeSUT()
        sut.setupSubscriptions(transactionsViewModel: transactionsViewModel, alertViewModel: alertViewModel)

        transactionsViewModel.error = nil
        XCTAssertFalse(alertViewModel.isActive)
        
        transactionsViewModel.error = anyNSError()
        XCTAssertTrue(alertViewModel.isActive)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        store: InMemoryStore = .withStoreData,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (TransactionsFlow, TransactionsViewModel, AlertViewModel) {
        let transactionsViewModel = TransactionsViewModel(retriever: store.retrivePublisher, saver: .none, deleter: .none)
        transactionsViewModel.retrieve()
        let alertViewModel = AlertViewModel()
        let sut = TransactionsFlow()
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(transactionsViewModel, file: file, line: line)
        trackForMemoryLeaks(alertViewModel, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, transactionsViewModel, alertViewModel)
    }
}
