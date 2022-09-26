//
//  PortfolioViewTests.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 26.09.2022.
//

import XCTest
import ViewInspector
import InvestmentsFrameworks
@testable import InvestmentsApp

extension PortfolioView: Inspectable {}
extension PortfolioRow: Inspectable {}

class PortfolioViewTests: XCTestCase {
    func test_portfolioView_rendersPortfolioItems() throws {
        let viewModel = PortfolioViewModel()
        let transactions = [
            Transaction(ticket: "BBB", type: .buy, quantity: 1, price: 10, sum: 10),
            Transaction(ticket: "AAA", type: .buy, quantity: 1, price: 10, sum: 10),
            Transaction(ticket: "AAA", type: .buy, quantity: 2, price: 20, sum: 20),
            Transaction(ticket: "AAA", type: .buy, quantity: 3, price: 10, sum: 30),
            Transaction(ticket: "BBB", type: .buy, quantity: 2, price: 20, sum: 20)
        ]
        let sut = PortfolioView(viewModel: viewModel)

        viewModel.createItems(for: transactions)
        
        XCTAssertEqual(try sut.items().count, 2)
        XCTAssertEqual(try sut.ticket(at: 0).string(), "AAA")
        XCTAssertEqual(try sut.ticket(at: 1).string(), "BBB")
        XCTAssertNoThrow(try sut.quantity(at: 0))
        XCTAssertNoThrow(try sut.quantity(at: 1))
        XCTAssertNoThrow(try sut.sum(at: 0))
        XCTAssertNoThrow(try sut.sum(at: 1))
    }
}

private extension PortfolioView {
    func items() throws -> InspectableView<ViewType.ForEach> {
        try self.inspect().find(viewWithAccessibilityIdentifier: "PORTFOLIO_ITEMS").forEach()
    }
    
    func ticket(at row: Int) throws -> InspectableView<ViewType.Text> {
        try item(at: row).find(viewWithAccessibilityIdentifier: "TICKET").text()
    }
    
    func sum(at row: Int) throws -> InspectableView<ViewType.Text> {
        try item(at: row).find(viewWithAccessibilityIdentifier: "SUM").text()
    }
    
    func quantity(at row: Int) throws -> InspectableView<ViewType.Text> {
        try item(at: row).find(viewWithAccessibilityIdentifier: "QUANTITY").text()
    }
    
    func item(at row: Int) throws -> InspectableView<ViewType.View<PortfolioRow>> {
        try self.items().view(PortfolioRow.self, row)
    }
}
