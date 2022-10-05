//
//  CurrentPricesAcceptranceTests.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 30.09.2022.
//

import XCTest
import Combine
import Foundation
import InvestmentsFrameworks
@testable import InvestmentsApp
@testable import ViewInspector

extension InvestmentsAcceptranceTests {
    func test_refreshPortfolio_leadsToRefreshCurrentPricesForAllTickets() throws {
        let sut = makeSUT(httpClient: .online(response), store: .empty)
        sut.currentPricesViewModel.currentPrices = makeCurrentPrices()
        let portfolioView = try sut.portfolioView()
        
        portfolioView.onRefresh()
        
        XCTAssertEqual(sut.currentPricesViewModel.currentPrices["AAA"], CurrentPrice(price: 100))
        XCTAssertEqual(sut.currentPricesViewModel.currentPrices["BBB"], CurrentPrice(price: 200))
    }
    
    func test_saveTransactionWithNewTicket_leadsToLoadCurrentPriceForTheTicket() throws {
        let sut = makeSUT(httpClient: .online(response), store: .empty)
        sut.currentPricesViewModel.currentPrices = makeCurrentPrices()

        sut.transactionsViewModel.save(Transaction(ticket: "AAA"))
        sut.transactionsViewModel.save(Transaction(ticket: "DDD"))
        
        XCTAssertEqual(sut.currentPricesViewModel.currentPrices["AAA"], CurrentPrice(price: 35))
        XCTAssertEqual(sut.currentPricesViewModel.currentPrices["DDD"], CurrentPrice(price: 400))
    }
    
    func test_currentPriceLoadError_leadsToActivateErrorMessage() throws {
        let sut = makeSUT(httpClient: .online(response), store: .empty)
        
        sut.currentPricesViewModel.error = "Any error"
        
        XCTAssertTrue(sut.alertViewModel.isActive)
    }
    
    func test_onLaunch_loadsCurrentPricesWhenUserHasConnectivity() throws {
        let sut = makeSUT(httpClient: .online(response), store: .withStoredData)

        XCTAssertTrue((try sut.portfolioView().price(at: 0).string()).contains("100"))
        XCTAssertTrue((try sut.portfolioView().price(at: 1).string()).contains("200"))
        XCTAssertTrue((try sut.portfolioView().price(at: 2).string()).contains("300"))
    }
    
    func test_onLaunch_loadsCachedCurrentPricesWhenUserHasNoConnectivityAndShowError() throws {
        let sharedStore = InMemoryStore.withStoredData
        let _ = makeSUT(httpClient: .online(response), store: sharedStore)
        let offlineSUT = makeSUT(httpClient: .offline, store: sharedStore)
        
        XCTAssertEqual(offlineSUT.currentPricesViewModel.currentPrices.count, 3)
        XCTAssertNotNil(offlineSUT.currentPricesViewModel.error)
        XCTAssertTrue(offlineSUT.alertViewModel.isActive)
        XCTAssertTrue((try offlineSUT.portfolioView().price(at: 0).string()).contains("100"))
        XCTAssertTrue((try offlineSUT.portfolioView().price(at: 1).string()).contains("200"))
        XCTAssertTrue((try offlineSUT.portfolioView().price(at: 2).string()).contains("300"))
    }
}
