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
        let (sut, viewModel) = makeSUT()
        let transactions = makePortfolioTransactions()
        let expectedPortfolio = makePortfolioItems()

        viewModel.createItems(for: transactions, with: CurrentPrices())
        
        XCTAssertEqual(try sut.items().count, 3)
        XCTAssertEqual(try sut.ticket(at: 0).string(), expectedPortfolio[0].ticket)
        XCTAssertEqual(try sut.ticket(at: 1).string(), expectedPortfolio[1].ticket)
        XCTAssertNoThrow(try sut.quantity(at: 0))
        XCTAssertNoThrow(try sut.quantity(at: 1))
        XCTAssertNoThrow(try sut.cost(at: 0))
        XCTAssertNoThrow(try sut.cost(at: 1))
        XCTAssertNoThrow(try sut.price(at: 0))
        XCTAssertNoThrow(try sut.price(at: 1))
        XCTAssertNoThrow(try sut.profit(at: 0))
        XCTAssertNoThrow(try sut.profit(at: 1))
        XCTAssertNoThrow(try sut.profitPercent(at: 0))
        XCTAssertNoThrow(try sut.profitPercent(at: 1))
    }
    
    func test_refresh_invokesOnRefresh() throws {
        var onRefreshInvokesCount = 0
        let (sut, _) = makeSUT {
            onRefreshInvokesCount += 1
        }
        
        try sut.refresh().tap()
        try sut.refresh().tap()
        
        XCTAssertEqual(onRefreshInvokesCount, 2)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        onRefresh: @escaping () -> Void = { },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (PortfolioView, PortfolioViewModel) {
        let viewModel = PortfolioViewModel()
        let sut = PortfolioView(viewModel: viewModel, onRefresh: onRefresh)
        
        trackForMemoryLeaks(viewModel, file: file, line: line)
        
        return (sut, viewModel)
    }
}

extension PortfolioView {
    func items() throws -> InspectableView<ViewType.ForEach> {
        try self.inspect().find(viewWithAccessibilityIdentifier: "PORTFOLIO_ITEMS").forEach()
    }
    
    func ticket(at row: Int) throws -> InspectableView<ViewType.Text> {
        try item(at: row).find(viewWithAccessibilityIdentifier: "TICKET").text()
    }
    
    func cost(at row: Int) throws -> InspectableView<ViewType.Text> {
        try item(at: row).find(viewWithAccessibilityIdentifier: "COST").text()
    }
    
    func quantity(at row: Int) throws -> InspectableView<ViewType.Text> {
        try item(at: row).find(viewWithAccessibilityIdentifier: "QUANTITY").text()
    }
    
    func price(at row: Int) throws -> InspectableView<ViewType.Text> {
        try item(at: row).find(viewWithAccessibilityIdentifier: "PRICE").text()
    }
    
    func profit(at row: Int) throws -> InspectableView<ViewType.Text> {
        try item(at: row).find(viewWithAccessibilityIdentifier: "PROFIT").text()
    }
    
    func profitPercent(at row: Int) throws -> InspectableView<ViewType.Text> {
        try item(at: row).find(viewWithAccessibilityIdentifier: "PROFIT_PERCENT").text()
    }
    
    func item(at row: Int) throws -> InspectableView<ViewType.View<PortfolioRow>> {
        try self.items().view(PortfolioRow.self, row)
    }
    
    func refresh() throws -> InspectableView<ViewType.Button> {
        try self.inspect().find(viewWithAccessibilityIdentifier: "REFRESH").button()
    }
}
