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
        let transactions = makePortfolioTransactions()
        let expectedPortfolio = makePortfolioItems()
        
        sut.createItems(for: transactions)
        
        XCTAssertEqual(sut.items, expectedPortfolio)
    }
}
