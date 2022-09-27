//
//  PortfolioFlowTests.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 27.09.2022.
//

import XCTest
import InvestmentsFrameworks
@testable import InvestmentsApp

class PortfolioFlowTests: XCTestCase {
    func test_saveTransaction_leadsToUpdatePortfolio() {
        let (sut, transactionsViewModel, portfolioViewModel) = makeSUT(transactions: [])
        
        sut.setupSubscriptions(portfolioViewModel: portfolioViewModel, transactionsViewModel: transactionsViewModel)
        
        XCTAssertEqual(portfolioViewModel.items, [])
        makePortfolioTransactions().forEach { transactionsViewModel.save($0) }
        XCTAssertEqual(portfolioViewModel.items, makePortfolioItems())
    }
    
    func test_initWithStoredTransactions_createsPotrfolioItems() {
        let (sut, transactionsViewModel, portfolioViewModel) = makeSUT(transactions: makePortfolioTransactions())
        
        sut.setupSubscriptions(portfolioViewModel: portfolioViewModel, transactionsViewModel: transactionsViewModel)
        
        XCTAssertEqual(portfolioViewModel.items, makePortfolioItems())
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        transactions: [Transaction],
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (PortfolioFlow, TransactionsViewModel, PortfolioViewModel) {
        let store = InMemoryTransactionsStore()
        store.transactions = transactions
        let transactionsViewModel = TransactionsViewModel(store: store)
        transactionsViewModel.retrieve()
        let portfolioViewModel = PortfolioViewModel()
        let sut = PortfolioFlow()
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(transactionsViewModel, file: file, line: line)
        trackForMemoryLeaks(portfolioViewModel, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, transactionsViewModel, portfolioViewModel)
    }
}
