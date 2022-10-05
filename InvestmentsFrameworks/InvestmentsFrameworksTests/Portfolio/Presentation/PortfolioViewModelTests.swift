//
//  PortfolioTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 26.09.2022.
//

import XCTest
import InvestmentsFrameworks

class PortfolioViewModelTests: XCTestCase {
    func test_createItems_calculatesPortfolioItemsAndSummary() {
        let sut = PortfolioViewModel()
        let transactions = makePortfolioTransactions()
        let currentPrices = makeCurrentPrices()
        let expectedPortfolio = makePortfolioItems(with: currentPrices)
        let expectedSummary = makePortfolioSummary(with: currentPrices)
        
        sut.createItems(for: transactions, with: currentPrices)
        
        XCTAssertEqual(sut.items, expectedPortfolio)
        XCTAssertEqual(sut.summary.cost, expectedSummary.cost)
        XCTAssertEqual(sut.summary.profit, expectedSummary.profit)
        XCTAssertEqual(round(sut.summary.profitPercent * 100) / 100 , expectedSummary.profitPercent)
    }
}
