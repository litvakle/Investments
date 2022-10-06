//
//  TransactionsAcceptanceTests.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 21.09.2022.
//

import XCTest
import ViewInspector
import InvestmentsFrameworks
@testable import InvestmentsApp

extension ContentView: Inspectable {}
extension ActivatableNavigationLink: Inspectable {}

extension InvestmentsAcceptranceTests {
    func test_onLaunch_rendersStoredTransactions() throws {
        let sut = makeSUT(httpClient: .offline, store: storeWithStoredTransactions)
        
        let transactionsView = try sut.transactionsView()
        
        XCTAssertEqual(try transactionsView.transactions().count, 2)
    }
    
    func test_onSaveTransaction_rendersSavedTransaction() throws {
        let sut = makeSUT(httpClient: .offline, store: storeWithStoredTransactions)
        let transactionsView = try sut.transactionsView()
        
        sut.transactionsViewModel.save(Transaction())

        XCTAssertEqual(try transactionsView.transactions().count, 3)
    }
    
    func test_onDeleteTransaction_doesNotRenderDeletedTransaction() throws {
        let sut = makeSUT(httpClient: .offline, store: storeWithStoredTransactions)
        let transactionsView = try sut.transactionsView()
        
        XCTAssertEqual(try transactionsView.transactions().count, 2)
        
        let indexSet: IndexSet = [0]
        try transactionsView.transactions().callOnDelete(indexSet)
        XCTAssertEqual(try transactionsView.transactions().count, 1)
        XCTAssertEqual(sut.transactionsViewModel.transactions.count, 1)
        
        try transactionsView.transactions().callOnDelete(indexSet)
        XCTAssertEqual(try transactionsView.transactions().count, 0)
        XCTAssertEqual(sut.transactionsViewModel.transactions.count, 0)
    }
    
    func test_onAddNewTransaction_navigatesToTransactionView() throws {
        let sut = makeSUT(httpClient: .offline, store: storeWithStoredTransactions)
        let transactionsView = try sut.transactionsView()
        
        XCTAssertFalse(sut.transactionsFlow.navigationState.isActive)
        try transactionsView.addNewTransaction().tap()
        XCTAssertTrue(sut.transactionsFlow.navigationState.isActive)
    }
    
    func test_onSaveNewTransaction_dismissesTransactionViewAndRendersSavedTransaction() throws {
        let sut = makeSUT(httpClient: .offline, store: storeWithStoredTransactions)
        let transactionsView = try sut.transactionsView()
        
        sut.transactionsFlow.selectedTransaction = Transaction(ticket: "MMM", type: .buy, quantity: 10, price:2, sum: 20)
        sut.transactionsFlow.navigationState.activate()
        
        let transactionView = try sut.transactionView()
        
        XCTAssertTrue(sut.transactionsFlow.navigationState.isActive)
        XCTAssertEqual(sut.transactionsViewModel.transactions.count, 2)
        XCTAssertEqual(try transactionsView.transactions().count, 2)
        
        try transactionView.saveTransaction().tap()
        
        XCTAssertFalse(sut.transactionsFlow.navigationState.isActive)
        XCTAssertEqual(sut.transactionsViewModel.transactions.count, 3)
        XCTAssertEqual(try transactionsView.transactions().count, 3)
    }
    
    // MARK: - Helpers
    
    private var storeWithStoredTransactions: InMemoryStore {
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