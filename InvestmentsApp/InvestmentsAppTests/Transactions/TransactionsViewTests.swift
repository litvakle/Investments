//
//  TransactionsViewTests.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 20.09.2022.
//

import XCTest
import ViewInspector
@testable import InvestmentsApp
@testable import InvestmentsFrameworks

extension TransactionsView: Inspectable {}
extension TransactionRow: Inspectable {}

class TransactionsViewTests: XCTestCase {
    func test_transactionView_rendersTransactions() throws {
        let store = InMemoryStore.withStoredData
        let sut  = makeSUT(store: .withStoredData)
        
        XCTAssertEqual(try sut.transactions().count, store.transactions.count)
    }
    
    func test_transactionView_rendersTransactionProperties() throws {
        let sut = makeSUT()
        
        XCTAssertFalse(try sut.ticket(at: 0).string().isEmpty)
        XCTAssertFalse(try sut.date(at: 0).string().isEmpty)
        XCTAssertFalse(try sut.quantity(at: 0).string().isEmpty)
        XCTAssertFalse(try sut.sum(at: 0).string().isEmpty)
    }
    
    func test_transactionView_handlesTransactionSelect() throws {
        var selectedTransactions = [Transaction?]()
        let sut = makeSUT(onSelect: { selectedTransaction in
            selectedTransactions.append(selectedTransaction)
        })
        
        let firstRowButton = try sut.transactions().button(0)
        let secondRowButton = try sut.transactions().button(1)
        
        try firstRowButton.tap()
        try firstRowButton.tap()
        try secondRowButton.tap()
        
        XCTAssertEqual(selectedTransactions, [sut.transactions[0], sut.transactions[0], sut.transactions[1]])
    }
    
    func test_transactionView_handlesTransactionDelete() throws {
        var deletedTransactions = [Transaction]()
        let sut = makeSUT(onDelete: { deletedTransaction in
            deletedTransactions.append(deletedTransaction)
        })
        
        let indexSet: IndexSet = [0]
        try sut.transactions().callOnDelete(indexSet)
        
        XCTAssertEqual(deletedTransactions, [sut.transactions[0]])
    }
    
    func test_transactionView_handlesAddNewTransaction() throws {
        var addNewTransactionInvokesCount = 0
        let sut = makeSUT(onSelect: { _ in
            addNewTransactionInvokesCount += 1
        })
        
        try sut.addNewTransaction().tap()
        try sut.addNewTransaction().tap()
        
        XCTAssertEqual(addNewTransactionInvokesCount, 2)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        store: InMemoryStore = .withStoredData,
        onSelect: @escaping (Transaction?) -> Void = { _ in },
        onDelete: @escaping (Transaction) -> Void = { _ in },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> TransactionsView {
        let store = InMemoryStore.withStoredData
        let viewModel = TransactionsViewModel(store: store)
        viewModel.retrieve()
        let sut = TransactionsView(
            transactions: viewModel.transactions,
            onTransactionSelect: onSelect,
            onTransactionDelete: onDelete)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(viewModel, file: file, line: line)
        
        return sut
    }
}
