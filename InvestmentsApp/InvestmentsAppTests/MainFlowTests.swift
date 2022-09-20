//
//  MainFlowTests.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 20.09.2022.
//

import XCTest
import InvestmentsFrameworks
@testable import InvestmentsApp

class MainFlowTests: XCTestCase {
    func test_transactionsError_leadsToAlert() {
        let store = TransactionsStoreStub()
        let transactionsViewModel = TransactionsViewModel(store: store)
        let alertViewModel = AlertViewModel()
        let sut = MainFlow()
        sut.subscribeTo(
            transactionsViewModel: transactionsViewModel,
            alertViewModel: alertViewModel
        )
        
        XCTAssertFalse(alertViewModel.isActive)
        XCTAssertTrue(alertViewModel.title.isEmpty)
        XCTAssertTrue(alertViewModel.message.isEmpty)
        
        transactionsViewModel.error = NSError(domain: "Any error", code: 0)
        
        XCTAssertEqual(alertViewModel.isActive, true)
        XCTAssertFalse(alertViewModel.title.isEmpty)
        XCTAssertFalse(alertViewModel.message.isEmpty)
    }
    
    // MARK: - Helpers
    
    private class TransactionsStoreStub: TransactionsStore {
        func retrieve() throws -> [Transaction] { [] }
        func save(_ transaction: Transaction) throws {}
        func delete(_ transaction: Transaction) throws {}
    }
}
