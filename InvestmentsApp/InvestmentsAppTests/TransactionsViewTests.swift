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

class TransactionsViewTests: XCTestCase {
    func test_transactionView_rendersTransactions() throws {
        let (sut, viewModel, store) = makeSUT()
        
        viewModel.retrieve()
        
        XCTAssertEqual(try sut.transactions().count, store.transactions.count)
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
    ) -> (sut: TransactionsView, viewModel: TransactionsViewModel, store: InMemoryTransactionsStore) {
        let store = InMemoryTransactionsStore()
        let viewModel = TransactionsViewModel(store: store)
        let sut = TransactionsView(
            viewModel: viewModel,
            onTransactionSelect: onSelect,
            onTransactionDelete: onDelete)
        
        return (sut, viewModel, store)
    }
    
    class InMemoryTransactionsStore: TransactionsStore {
        var transactions = [
            Transaction(ticket: "VOO", type: .buy, quantity: 2, price: 10, sum: 20),
            Transaction(ticket: "QQQ", type: .sell, quantity: 1, price: 100, sum: 100)
        ]
        
        func retrieve() throws -> [Transaction] {
            return transactions
        }
        
        func save(_ transaction: Transaction) throws {
            if let index = transactions.firstIndex(of: transaction) {
                transactions[index] = transaction
            } else {
                transactions.append(transaction)
            }
        }
        
        func delete(_ transaction: Transaction) throws {
            if let index = transactions.firstIndex(of: transaction) {
                transactions.remove(at: index)
            }
        }
    }
}

private extension TransactionsView {
    func transactions() throws -> InspectableView<ViewType.ForEach> {
        try self.inspect().find(viewWithAccessibilityIdentifier: "TRANSACTIONS").forEach()
    }
    
    func addNewTransaction() throws -> InspectableView<ViewType.Button> {
        try self.inspect().find(viewWithAccessibilityIdentifier: "ADD_NEW_TRANSACTION").button()
    }
}
