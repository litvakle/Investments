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
        let (sut, transactionsFlow, _) = makeSUT()
        let transactionsView = try sut.transactionsView()
        
        XCTAssertFalse(transactionsFlow.navigationState.isActive)
        
        try transactionsView.addNewTransaction().tap()
        
        XCTAssertTrue(transactionsFlow.navigationState.isActive)
    }
    
    func test_onSaveNewTransaction_dismissesTransactionViewAndRendersSavedTransaction() throws {
        let (sut, transactionsFlow, transactionsViewModel) = makeSUT()
        let transactionsView = try sut.transactionsView()
        
        transactionsFlow.selectedTransaction = Transaction(ticket: "MMM", type: .buy, quantity: 10, price:2, sum: 20)
        transactionsFlow.navigationState.activate()
        
        let transactionView = try sut.transactionView()
        
        XCTAssertTrue(transactionsFlow.navigationState.isActive)
        XCTAssertEqual(transactionsViewModel.transactions.count, 2)
        XCTAssertEqual(try transactionsView.transactions().count, 2)
        
        try transactionView.saveTransaction().tap()
        
        XCTAssertFalse(transactionsFlow.navigationState.isActive)
        XCTAssertEqual(transactionsViewModel.transactions.count, 3)
        XCTAssertEqual(try transactionsView.transactions().count, 3)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        store: InMemoryStore = storeWithStoredTransactions,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: ContentView, transactionsFlow: TransactionsFlow, transactionsViewModel: TransactionsViewModel) {
        let transactionsViewModel = TransactionsViewModelFactory.createViewModel(store: store)
        let alertViewModel = AlertViewModel()
        let transactionsFlow = TransactionsFlow()
        let portfolioFlow = PortfolioFlow()
        let portfolioViewModel = PortfolioViewModel()
        let currentPricesFlow = CurrentPricesFlow()
        let currentPriceLoader = CurrentPriceLoaderSpy()
        let currentPricesViewModel = CurrentPricesViewModel(loader: currentPriceLoader.loadPublisher)
        let sut = ContentView(
            transactionsViewModel: transactionsViewModel,
            portfolioViewModel: portfolioViewModel,
            currentPricesViewModel: currentPricesViewModel,
            alertViewModel: alertViewModel,
            transactionsFlow: transactionsFlow,
            portfolioFlow: portfolioFlow,
            currentPricesFlow: currentPricesFlow
        )

        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(transactionsViewModel, file: file, line: line)
        trackForMemoryLeaks(portfolioViewModel, file: file, line: line)
        trackForMemoryLeaks(alertViewModel, file: file, line: line)
        trackForMemoryLeaks(currentPriceLoader, file: file, line: line)
        trackForMemoryLeaks(currentPricesViewModel, file: file, line: line)
        trackForMemoryLeaks(transactionsFlow, file: file, line: line)
        trackForMemoryLeaks(portfolioFlow, file: file, line: line)
        
        return (sut, transactionsFlow, transactionsViewModel)
    }
    
    private func currentPriceLoader() -> AnyPublisher<CurrentPrice, Error> {
        PassthroughSubject<CurrentPrice, Error>().eraseToAnyPublisher()
    }
    
    static private var storeWithStoredTransactions: InMemoryStore {
        InMemoryStore(
            transactions: [
                Transaction(ticket: "AAA", quantity: 2, price: 10, sum: 20),
                Transaction(ticket: "BBB", quantity: 1, price: 30, sum: 30)
            ]
        )
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
