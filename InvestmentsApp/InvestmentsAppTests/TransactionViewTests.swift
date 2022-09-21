//
//  TransactionViewTests.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 21.09.2022.
//

import XCTest
import ViewInspector
@testable import InvestmentsApp
@testable import InvestmentsFrameworks

extension TransactionView: Inspectable {}

class TransactionViewTests: XCTestCase {
    func test_transactionView_rendersTransactionProperties() throws {
        let (sut, _) = makeSUT(for: newTransaction())
        
        XCTAssertNoThrow(try sut.type())
        XCTAssertNoThrow(try sut.date())
        XCTAssertNoThrow(try sut.ticket())
        XCTAssertNoThrow(try sut.quantity())
        XCTAssertNoThrow(try sut.sum())
        XCTAssertNoThrow(try sut.price())
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        for transaction: Transaction,
        onSave: @escaping (Transaction?) -> Void = { _ in },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: TransactionView, viewModel: TransactionViewModel) {
        let viewModel = TransactionViewModel(transaction: transaction, onSave: onSave)
        let sut = TransactionView(viewModel)
        
        trackForMemoryLeaks(viewModel, file: file, line: line)
        
        return (sut, viewModel)
    }
    
    private func newTransaction() -> Transaction {
        Transaction(ticket: "", type: .buy, quantity: 0, price: 0, sum: 0)
    }
}

private extension TransactionView {
    func type() throws -> InspectableView<ViewType.Picker> {
        try self.inspect().find(viewWithAccessibilityIdentifier: "TYPE").picker()
    }
    
    func date() throws -> InspectableView<ViewType.DatePicker> {
        try self.inspect().find(viewWithAccessibilityIdentifier: "DATE").datePicker()
    }
    
    func ticket() throws -> InspectableView<ViewType.TextField> {
        try self.inspect().find(viewWithAccessibilityIdentifier: "TICKET").textField()
    }
    
    func quantity() throws -> InspectableView<ViewType.TextField> {
        try self.inspect().find(viewWithAccessibilityIdentifier: "QUANTITY").textField()
    }
    
    func sum() throws -> InspectableView<ViewType.TextField> {
        try self.inspect().find(viewWithAccessibilityIdentifier: "SUM").textField()
    }
    
    func price() throws -> InspectableView<ViewType.Text> {
        try self.inspect().find(viewWithAccessibilityIdentifier: "PRICE").text()
    }
}
