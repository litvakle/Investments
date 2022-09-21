//
//  TransactionsView+ViewInspector.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 21.09.2022.
//

import ViewInspector
@testable import InvestmentsApp

extension TransactionsView {
    func transactions() throws -> InspectableView<ViewType.ForEach> {
        try self.inspect().find(viewWithAccessibilityIdentifier: "TRANSACTIONS").forEach()
    }
    
    func addNewTransaction() throws -> InspectableView<ViewType.Button> {
        try self.inspect().find(viewWithAccessibilityIdentifier: "ADD_NEW_TRANSACTION").button()
    }
    
    func ticket(at row: Int) throws -> InspectableView<ViewType.Text> {
        return try transaction(at: row).find(viewWithAccessibilityIdentifier: "TICKET").text()
    }
    
    func date(at row: Int) throws -> InspectableView<ViewType.Text> {
        return try transaction(at: row).find(viewWithAccessibilityIdentifier: "DATE").text()
    }
    
    func quantity(at row: Int) throws -> InspectableView<ViewType.Text> {
        return try transaction(at: row).find(viewWithAccessibilityIdentifier: "QUANTITY").text()
    }
    
    func sum(at row: Int) throws -> InspectableView<ViewType.Text> {
        return try transaction(at: row).find(viewWithAccessibilityIdentifier: "SUM").text()
    }
    
    private func transaction(at index: Int) throws -> InspectableView<ViewType.View<TransactionRow>> {
        try self.transactions().button(index).labelView().view(TransactionRow.self)
    }
}
