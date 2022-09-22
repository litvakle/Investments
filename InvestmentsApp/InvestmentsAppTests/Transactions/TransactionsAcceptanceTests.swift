//
//  TransactionsAcceptanceTests.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 21.09.2022.
//

import XCTest
import ViewInspector
@testable import InvestmentsApp

extension ContentView: Inspectable {}

class TransactionsAcceptanceTests: XCTestCase {
    func test_onLaunch_displaysStoredTransactions() throws {
        let sut = makeSUT()
        
        let transactionsView = try sut.transactionsView()
        
        XCTAssertEqual(try transactionsView.transactions().count, 2)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> ContentView {
        let store = InMemoryTransactionsStore()
        let transactionsViewModel = TransactionsViewModelFactory.createViewModel(store: store)
        let alertViewModel = AlertViewModel()
        let mainFlow = MainFlow()
        let sut = ContentView(
            transactionsViewModel: transactionsViewModel,
            alertViewModel: alertViewModel,
            mainFlow: mainFlow
        )

        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(transactionsViewModel, file: file, line: line)
        trackForMemoryLeaks(alertViewModel, file: file, line: line)
        trackForMemoryLeaks(mainFlow, file: file, line: line)
        
        return sut
    }
}

private extension ContentView {
    func transactionsView() throws -> TransactionsView {
        try self.inspect().find(TransactionsView.self).actualView()
    }
}
