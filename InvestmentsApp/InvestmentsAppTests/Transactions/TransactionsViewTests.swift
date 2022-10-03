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
        let (sut, viewModel, store) = makeSUT()
        
        viewModel.retrieve()
        
        XCTAssertEqual(try sut.transactions().count, store.transactions.count)
    }
    
    func test_transactionView_rendersTransactionProperties() throws {
        let (sut, viewModel, _) = makeSUT()
        
        viewModel.retrieve()
        
        XCTAssertFalse(try sut.ticket(at: 0).string().isEmpty)
        XCTAssertFalse(try sut.date(at: 0).string().isEmpty)
        XCTAssertFalse(try sut.quantity(at: 0).string().isEmpty)
        XCTAssertFalse(try sut.sum(at: 0).string().isEmpty)
    }
    
    func test_transactionView_handlesTransactionSelect() throws {
        var selectedTransactions = [Transaction?]()
        let (sut, viewModel, store) = makeSUT(onSelect: { selectedTransaction in
            selectedTransactions.append(selectedTransaction)
        })
        
        viewModel.retrieve()
        
        let firstRowButton = try sut.transactions().button(0)
        let secondRowButton = try sut.transactions().button(1)
        
        try firstRowButton.tap()
        try firstRowButton.tap()
        try secondRowButton.tap()
        
        XCTAssertEqual(selectedTransactions, [store.transactions[0], store.transactions[0], store.transactions[1]])
    }
    
    func test_transactionView_handlesTransactionDelete() throws {
        var deletedTransactions = [Transaction]()
        let (sut, viewModel, store) = makeSUT(onDelete: { deletedTransaction in
            deletedTransactions.append(deletedTransaction)
        })
        
        viewModel.retrieve()
        
        let indexSet: IndexSet = [0]
        try sut.transactions().callOnDelete(indexSet)
        
        XCTAssertEqual(deletedTransactions, [store.transactions[0]])
    }
    
    func test_transactionView_handlesAddNewTransaction() throws {
        var addNewTransactionInvokesCount = 0
        let (sut, _, _) = makeSUT(onSelect: { _ in
            addNewTransactionInvokesCount += 1
        })
        
        try sut.addNewTransaction().tap()
        try sut.addNewTransaction().tap()
        
        XCTAssertEqual(addNewTransactionInvokesCount, 2)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        onSelect: @escaping (Transaction?) -> Void = { _ in },
        onDelete: @escaping (Transaction) -> Void = { _ in },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: TransactionsView, viewModel: TransactionsViewModel, store: InMemoryStore) {
        let store = InMemoryStore.withStoredData
        let viewModel = TransactionsViewModel(store: store)
        let sut = TransactionsView(
            viewModel: viewModel,
            onTransactionSelect: onSelect,
            onTransactionDelete: onDelete)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(viewModel, file: file, line: line)
        
        return (sut, viewModel, store)
    }
}
