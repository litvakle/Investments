//
//  TransactionsAcceptanceTests.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 21.09.2022.
//

import XCTest
import ViewInspector
import Combine
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
        let (sut, _, transactionsViewModel) = makeSUT()
        let transactionsView = try sut.transactionsView()
        
        XCTAssertEqual(try transactionsView.transactions().count, 2)
        
        let indexSet: IndexSet = [0]
        try transactionsView.transactions().callOnDelete(indexSet)
        XCTAssertEqual(try transactionsView.transactions().count, 1)
        XCTAssertEqual(transactionsViewModel.transactions.count, 1)
        
        try transactionsView.transactions().callOnDelete(indexSet)
        XCTAssertEqual(try transactionsView.transactions().count, 0)
        XCTAssertEqual(transactionsViewModel.transactions.count, 0)
    }
    
    func test_onAddNewTransaction_navigatesToTransactionView() throws {
        let (sut, mainFlow, _) = makeSUT()
        let transactionsView = try sut.transactionsView()
        
        XCTAssertFalse(mainFlow.navigationState.isActive)
        
        try transactionsView.addNewTransaction().tap()
        
        XCTAssertTrue(mainFlow.navigationState.isActive)
    }
    
    func test_onSaveNewTransaction_dismissesTransactionViewAndRendersSavedTransaction() throws {
        let (sut, mainFlow, transactionsViewModel) = makeSUT()
        let transactionsView = try sut.transactionsView()
        
        mainFlow.selectedTransaction = Transaction(ticket: "MMM", type: .buy, quantity: 10, price:2, sum: 20)
        mainFlow.navigationState.activate()
        
        let transactionView = try sut.transactionView()
        
        XCTAssertTrue(mainFlow.navigationState.isActive)
        XCTAssertEqual(transactionsViewModel.transactions.count, 2)
        XCTAssertEqual(try transactionsView.transactions().count, 2)
        
        try transactionView.saveTransaction().tap()
        
        XCTAssertFalse(mainFlow.navigationState.isActive)
        XCTAssertEqual(transactionsViewModel.transactions.count, 3)
        XCTAssertEqual(try transactionsView.transactions().count, 3)
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
        let portfolioFlow = PortfolioFlow()
        let portfolioViewModel = PortfolioViewModel()
        let sut = ContentView(
            transactionsViewModel: transactionsViewModel,
            portfolioViewModel: portfolioViewModel,
            currentPricesViewModel: CurrentPricesViewModel(loader: currentPriceLoader),
            alertViewModel: alertViewModel,
            mainFlow: mainFlow,
            portfolioFlow: portfolioFlow
        )

        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(transactionsViewModel, file: file, line: line)
        trackForMemoryLeaks(portfolioViewModel, file: file, line: line)
        trackForMemoryLeaks(alertViewModel, file: file, line: line)
        trackForMemoryLeaks(mainFlow, file: file, line: line)
        trackForMemoryLeaks(portfolioFlow, file: file, line: line)
        
        return (sut, mainFlow, transactionsViewModel)
    }
    
    private func currentPriceLoader() -> AnyPublisher<CurrentPrice, Error> {
        PassthroughSubject<CurrentPrice, Error>().eraseToAnyPublisher()
    }
}

private extension ContentView {
    func transactionsView() throws -> TransactionsView {
        try self.inspect().find(TransactionsView.self).actualView()
    }
    
    func transactionView() throws -> TransactionView {
        try self.inspect().find(viewWithAccessibilityIdentifier: "NAVIGATION_LINK_TO_TRANSACTION_VIEW")
            .view(ActivatableNavigationLink<TransactionView>.self)
            .find(ViewType.NavigationLink.self)
            .view(TransactionView.self).actualView()
    }
    
    
}
