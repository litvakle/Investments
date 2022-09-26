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
extension ActivatableNavigationLink: Inspectable {}

class TransactionsAcceptanceTests: XCTestCase {
    func test_onLaunch_rendersStoredTransactions() throws {
        let (sut, _, _) = makeSUT()
        
        let transactionsView = try sut.transactionsView()
        
        XCTAssertEqual(try transactionsView.transactions().count, 2)
    }
    
    func test_onSaveTransaction_rendersSavedTransaction() throws {
        let (sut, _, transactionsViewModel) = makeSUT()
        let transactionsView = try sut.transactionsView()
        
        transactionsViewModel.save(Transaction())

        XCTAssertEqual(try transactionsView.transactions().count, 3)
    }
    
    func test_onDeleteTransaction_doesNotRenderDeletedTransaction() throws {
        let (sut, _, _) = makeSUT()
        let transactionsView = try sut.transactionsView()
        
        XCTAssertEqual(try transactionsView.transactions().count, 2)
        
        let indexSet: IndexSet = [0]
        try transactionsView.transactions().callOnDelete(indexSet)

        XCTAssertEqual(try transactionsView.transactions().count, 1)
    }
    
    func test_onAddNewTransaction_navigatesToTransactionView() throws {
        let (sut, mainFlow, _) = makeSUT()
        let transactionsView = try sut.transactionsView()
        
        XCTAssertFalse(mainFlow.navigationState.isActive)
        
        try transactionsView.addNewTransaction().tap()
        
        XCTAssertTrue(mainFlow.navigationState.isActive)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: ContentView, mainFlow: MainFlow, transactionsViewModel: TransactionsViewModel) {
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
        
        return (sut, mainFlow, transactionsViewModel)
    }
}

private extension ContentView {
    func transactionsView() throws -> TransactionsView {
        try self.inspect().find(TransactionsView.self).actualView()
    }
    
    func transactionView() throws -> TransactionView {
        try self.inspect().find(ViewType.NavigationLink.self).view(TransactionView.self).actualView()
    }
}
