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

class CurrentPricesAcceptranceTests: XCTestCase {
    func test_refreshPortfolio_leadsToRefreshCurrentPricesForAllTickets() throws {
        let (sut, _, currentPricesViewModel, currentPriceLoader, _) = makeSUT()
        try sut.callOnAppear()
        currentPricesViewModel.currentPrices = makeCurrentPrices()
        let portfolioView = try sut.portfolioView()
        
        portfolioView.onRefresh()
        
        XCTAssertEqual(currentPriceLoader.requests.count, 2)
    }
    
    func test_saveTransactionWithNewTicket_leadsToLoadCurrentPriceForTheTicket() throws {
        let (sut, transactionsVewModel, currentPricesViewModel, currentPriceLoader, _) = makeSUT()
        try sut.callOnAppear()
        currentPricesViewModel.currentPrices = makeCurrentPrices()

        transactionsVewModel.save(Transaction(ticket: "AAA"))
        transactionsVewModel.save(Transaction(ticket: "DDD"))
        
        XCTAssertEqual(currentPriceLoader.requests.count, 1)
    }
    
    func test_currentPriceLoadError_leadsToActivateErrorMessage() throws {
        let (sut, _, currentPricesViewModel, _, alertViewModel) = makeSUT()
        try sut.callOnAppear()
        
        currentPricesViewModel.error = "Any error"
        
        XCTAssertTrue(alertViewModel.isActive)
    }
    
    func test_onLaunch_loadsCurrentPricesWhenUserHasConnectivity() throws {
        let sut = launch(httpClient: .online(response), store: .withStoredData)
        try sut.callOnAppear()
        
        let exp = expectation(description: "Wait for load prices")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        XCTAssertTrue((try sut.portfolioView().price(at: 0).string()).contains("100"))
        XCTAssertTrue((try sut.portfolioView().price(at: 1).string()).contains("200"))
        XCTAssertTrue((try sut.portfolioView().price(at: 2).string()).contains("300"))
    }
    
    private func makeSUT(
        httpClient: HTTPClientStub = .offline,
        store: InMemoryStore = .empty,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (ContentView, TransactionsViewModel, CurrentPricesViewModel, CurrentPriceLoaderSpy, AlertViewModel) {
        let transactionsViewModel = TransactionsViewModelFactory.createViewModel(store: store)
        let alertViewModel = AlertViewModel()
        let mainFlow = MainFlow()
        let portfolioViewModel = PortfolioViewModel()
        let portfolioFlow = PortfolioFlow()
        let currentPriceLoader = CurrentPriceLoaderSpy()
        let currentPricesViewModel = CurrentPricesViewModel(loader: currentPriceLoader.loadPublisher)
        let currentPricesFlow = CurrentPricesFlow()
        let sut = ContentView(
            transactionsViewModel: transactionsViewModel,
            portfolioViewModel: portfolioViewModel,
            currentPricesViewModel: currentPricesViewModel,
            alertViewModel: alertViewModel,
            mainFlow: mainFlow,
            portfolioFlow: portfolioFlow,
            currentPricesFlow: currentPricesFlow
        )
        
        trackForMemoryLeaks(portfolioViewModel, file: file, line: line)
        trackForMemoryLeaks(transactionsViewModel, file: file, line: line)
        trackForMemoryLeaks(alertViewModel, file: file, line: line)
        trackForMemoryLeaks(mainFlow, file: file, line: line)
        trackForMemoryLeaks(portfolioFlow, file: file, line: line)
        
        return (sut, transactionsViewModel, currentPricesViewModel, currentPriceLoader, alertViewModel)
    }
    
    private func launch(
        httpClient: HTTPClientStub,
        store: InMemoryStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> ContentView {
        let transactionsViewModel = TransactionsViewModelFactory.createViewModel(store: store)
        let alertViewModel = AlertViewModel()
        let mainFlow = MainFlow()
        let portfolioViewModel = PortfolioViewModel()
        let portfolioFlow = PortfolioFlow()
        let loaderFactory = CurrentPricesLoaderFactory(
            httpClient: httpClient,
            baseURL: URL(string: "http://base-url.com")!,
            token: "token",
            store: store
        )
        let currentPricesViewModel = CurrentPricesViewModel(loader: loaderFactory.makeRemoteCurrentPriceLoader)
        let currentPricesFlow = CurrentPricesFlow()
        let sut = ContentView(
            transactionsViewModel: transactionsViewModel,
            portfolioViewModel: portfolioViewModel,
            currentPricesViewModel: currentPricesViewModel,
            alertViewModel: alertViewModel,
            mainFlow: mainFlow,
            portfolioFlow: portfolioFlow,
            currentPricesFlow: currentPricesFlow
        )
        
        trackForMemoryLeaks(portfolioViewModel, file: file, line: line)
        trackForMemoryLeaks(transactionsViewModel, file: file, line: line)
        trackForMemoryLeaks(alertViewModel, file: file, line: line)
        trackForMemoryLeaks(mainFlow, file: file, line: line)
        trackForMemoryLeaks(portfolioFlow, file: file, line: line)
        
        return sut
    }
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }
    
    private func makeData(for url: URL) -> Data {
        switch url.path {
        case "/v1/quote" where url.query?.contains("AAA") == true:
            return try! JSONSerialization.data(withJSONObject: ["c": 100])
            
        case "/v1/quote" where url.query?.contains("BBB") == true:
            return try! JSONSerialization.data(withJSONObject: ["c": 200])
            
        case "/v1/quote" where url.query?.contains("CCC") == true:
            return try! JSONSerialization.data(withJSONObject: ["c": 300])
            
        default:
            return Data()
        }
    }
}

class HTTPClientStub: HTTPClient {
    private class Task: HTTPClientTask {
        func cancel() {}
    }
    
    private let stub: (URL) -> HTTPClient.Result
    
    init(stub: @escaping (URL) -> HTTPClient.Result) {
        self.stub = stub
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        completion(stub(url))
        return Task()
    }
}

extension HTTPClientStub {
    static var offline: HTTPClientStub {
        HTTPClientStub(stub: { _ in .failure(NSError(domain: "offline", code: 0)) })
    }
    
    static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
        HTTPClientStub { url in .success(stub(url)) }
    }
}
