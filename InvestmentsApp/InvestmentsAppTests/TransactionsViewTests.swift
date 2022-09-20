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
        
        XCTAssertEqual(try sut.inspect().list().forEach(0).count, store.transactions.count)
    }
    
    func test_transactionView_handlesTransactionSelect() throws {
        var selectedTransactions = [Transaction?]()
        let (sut, viewModel, store) = makeSUT(onSelect: { selectedTransaction in
            selectedTransactions.append(selectedTransaction)
        })
        
        viewModel.retrieve()
        try sut.inspect().list().forEach(0).button(0).tap()
        try sut.inspect().list().forEach(0).button(0).tap()
        try sut.inspect().list().forEach(0).button(1).tap()
        
        XCTAssertEqual(selectedTransactions, [store.transactions[0], store.transactions[0], store.transactions[1]])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        onSelect: @escaping (Transaction?) -> Void = { _ in },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: TransactionsView, viewModel: TransactionsViewModel, store: InMemoryTransactionsStore) {
        let store = InMemoryTransactionsStore()
        let viewModel = TransactionsViewModel(store: store)
        let sut = TransactionsView(
            viewModel: viewModel,
            onTransactionSelect: onSelect,
            onTransactionDelete: { _ in })
        
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
