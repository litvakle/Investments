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
        let store = InMemoryTransactionsStore()
        let viewModel = TransactionsViewModel(store: store)
        let sut = TransactionsView(viewModel: viewModel, onTransactionSelect: { _ in }, onTransactionDelete: { _ in })
        
        viewModel.retrieve()
        
        XCTAssertEqual(try sut.inspect().list().forEach(0).count, store.transactions.count)
    }
    
    // MARK: - Helpers
    
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
