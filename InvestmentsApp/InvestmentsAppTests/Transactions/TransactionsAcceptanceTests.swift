//
//  TransactionsAcceptanceTests.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 21.09.2022.
//

import XCTest
import ViewInspector
@testable import InvestmentsApp
@testable import InvestmentsFrameworks

extension ContentView: Inspectable {}

class TransactionsAcceptanceTests: XCTestCase {
    func test_onLaunch_displaysStoredTransactions() throws {
        let (sut, _) = makeSUT()
        
        let transactionsView = try sut.transactionsView()
        
        XCTAssertEqual(try transactionsView.transactions().count, 2)
    }
    
    func test_onSaveTransaction_displaysSavedTransaction() throws {
        let (sut, transactionsViewModel) = makeSUT()
        let transactionsView = try sut.transactionsView()
        
        transactionsViewModel.save(Transaction())

        XCTAssertEqual(try transactionsView.transactions().count, 3)
    }
    
    func test_onDeleteTransaction_doesNotDisplaysDeletedTransaction() throws {
        let (sut, transactionsViewModel) = makeSUT()
        let transactionsView = try sut.transactionsView()
        
        transactionsViewModel.delete(transactionsViewModel.transactions[0])

        XCTAssertEqual(try transactionsView.transactions().count, 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: ContentView, transactionsViewModel: TransactionsViewModel) {
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
        
        return (sut, transactionsViewModel)
    }
}

private extension ContentView {
    func transactionsView() throws -> TransactionsView {
        try self.inspect().find(TransactionsView.self).actualView()
    }
}
