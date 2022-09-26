//
//  PortfolioTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 26.09.2022.
//

import XCTest
import InvestmentsFrameworks

class PortfolioTests: XCTestCase {
    func test_createItems_calculatesTotalParametersForAllTickets() {
        let sut = PortfolioViewModel()
        let transactions = [
            Transaction(ticket: "BBB", type: .buy, quantity: 1, price: 10, sum: 10),
            Transaction(ticket: "AAA", type: .buy, quantity: 1, price: 10, sum: 10),
            Transaction(ticket: "AAA", type: .buy, quantity: 2, price: 20, sum: 20),
            Transaction(ticket: "AAA", type: .buy, quantity: 3, price: 10, sum: 30),
            Transaction(ticket: "BBB", type: .buy, quantity: 2, price: 20, sum: 20)
        ]
        let expectedItem0 = PortfolioItem(ticket: "AAA", quantity: 6, sum: 60)
        let expectedItem1 = PortfolioItem(ticket: "BBB", quantity: 3, sum: 30)
        
        sut.createItems(for: transactions)
        
        XCTAssertEqual(sut.items, [expectedItem0, expectedItem1])
    }
}
