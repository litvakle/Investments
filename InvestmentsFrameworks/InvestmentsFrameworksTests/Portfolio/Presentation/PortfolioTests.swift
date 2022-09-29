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
        let currentPrices = makeCurrentPrices()
        let expectedPortfolio = makePortfolioItems(with: currentPrices)
        
        sut.createItems(for: transactions, with: currentPrices)
        
        XCTAssertEqual(sut.items, expectedPortfolio)
    }
}
