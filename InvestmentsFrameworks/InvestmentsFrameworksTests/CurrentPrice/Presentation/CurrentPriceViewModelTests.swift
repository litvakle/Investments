//
//  CurrentPriceViewModelTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 28.09.2022.
//

import XCTest
import Combine
import InvestmentsFrameworks

class CurrentPriceViewModelTests: XCTestCase {
    func test_init_doesNotRequestLoader() {
        let (_, loader) = makeSUT()
        
        XCTAssertTrue(loader.requests.isEmpty)
    }
    
    func test_loadPrices_requestsLoader() {
        let (sut, loader) = makeSUT()
        let tickets = ["AAA", "BBB"]
        
        sut.loadPrices(for: tickets)
        
        XCTAssertEqual(loader.requests.count, 2)
    }
    
    func test_loadPrices_doesNotRequestLoaderIfItIsBusy() {
        let (sut, loader) = makeSUT()
        let tickets0 = ["AAA", "BBB"]
        let tickets1 = ["CCC"]
        
        sut.loadPrices(for: tickets0)
        sut.loadPrices(for: tickets1)
        XCTAssertEqual(loader.requests.count, 2)
    }
    
    func test_loadPrices_deliversErrorOnErrorWithAtLeastOneTicket() {
        let (sut, loader) = makeSUT()
        let tickets = ["AAA", "BBB", "CCC", "DDD", "EEE"]
        
        XCTAssertNil(sut.error)
        
        sut.loadPrices(for: tickets)
        loader.completeCurrentPriceLoading(with: CurrentPrice(price: 0), at: 0)
        loader.completeCurrentPriceLoading(with: CurrentPrice(price: 0), at: 1)
        loader.completeCurrentPriceLoadingWithError(at: 2)
        loader.completeCurrentPriceLoading(with: CurrentPrice(price: 0), at: 3)
        loader.completeCurrentPriceLoading(with: CurrentPrice(price: 0), at: 4)
        
        XCTAssertNotNil(sut.error)
    }
    
    func test_loadPrices_doesNotDeliverErrorOnSuccessfulLoadAfterLoadWithError() {
        let (sut, loader) = makeSUT()
        let tickets0 = ["AAA", "BBB"]
        let tickets1 = ["CCC", "DDD"]
        
        sut.loadPrices(for: tickets0)
        loader.completeCurrentPriceLoadingWithError(at: 0)
        loader.completeCurrentPriceLoading(with: CurrentPrice(price: 0), at: 1)
        
        sut.loadPrices(for: tickets1)
        loader.completeCurrentPriceLoading(with: CurrentPrice(price: 0), at: 2)
        loader.completeCurrentPriceLoading(with: CurrentPrice(price: 0), at: 3)
        
        XCTAssertNil(sut.error)
    }
    
    func test_loadPrices_deliversCurrentPricesForSuccessfulLoads() {
        let (sut, loader) = makeSUT()
        let tickets = ["AAA", "BBB", "CCC"]
        
        sut.loadPrices(for: tickets)
        loader.completeCurrentPriceLoadingWithError(at: 0)
        loader.completeCurrentPriceLoading(with: CurrentPrice(price: 10), at: 1)
        loader.completeCurrentPriceLoading(with: CurrentPrice(price: 20), at: 2)
        
        XCTAssertNil(sut.currentPrices["AAA"])
        XCTAssertEqual(sut.currentPrices["BBB"]?.price, 10)
        XCTAssertEqual(sut.currentPrices["CCC"]?.price, 20)
    }
    
    func test_loadPrices_updatesPreviouslyLoadedPricesOnlyOnSuccessfulLoads() {
        let (sut, loader) = makeSUT()
        sut.currentPrices["AAA"] = CurrentPrice(price: 10)
        sut.currentPrices["BBB"] = CurrentPrice(price: 20)
        sut.currentPrices["CCC"] = CurrentPrice(price: 30)
        let tickets = ["AAA", "BBB", "CCC"]
        
        sut.loadPrices(for: tickets)
        loader.completeCurrentPriceLoading(with: CurrentPrice(price: 100), at: 0)
        loader.completeCurrentPriceLoading(with: CurrentPrice(price: 200), at: 1)
        loader.completeCurrentPriceLoadingWithError(at: 2)
        
        XCTAssertEqual(sut.currentPrices["AAA"]?.price, 100)
        XCTAssertEqual(sut.currentPrices["BBB"]?.price, 200)
        XCTAssertEqual(sut.currentPrices["CCC"]?.price, 30)
    }
    
    func test_loadPrices_makesOverallLoadingIndicatorsAndForEachTicketOnAtStartAndOffAfterLoading() {
        let (sut, loader) = makeSUT()
        let tickets = ["AAA", "BBB"]
        
        XCTAssertFalse(sut.isLoading)
        sut.loadPrices(for: tickets)
        XCTAssertEqual(sut.loadingTickets, ["AAA", "BBB"])
        XCTAssertTrue(sut.isLoading)
        
        loader.completeCurrentPriceLoading(with: CurrentPrice(price: 100), at: 1)
        XCTAssertEqual(sut.loadingTickets, ["AAA"])
        XCTAssertTrue(sut.isLoading)
        
        loader.completeCurrentPriceLoadingWithError(at: 0)
        XCTAssertEqual(sut.loadingTickets, [])
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_refresh_invokesLoadingPricesForAllExistingTickets() {
        let (sut, loader) = makeSUT()
        sut.currentPrices = [
            "AAA": CurrentPrice(price: 100),
            "BBB": CurrentPrice(price: 200),
            "CCC": CurrentPrice(price: 300)
        ]
        
        sut.refreshPrices()
        
        XCTAssertEqual(loader.requests.count, 3)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (CurrentPricesViewModel, LoaderSpy) {
        let loader = LoaderSpy()
        let sut = CurrentPricesViewModel(loader: loader.loadPublisher)
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader)
    }
    
    private class LoaderSpy {
        var requests = [(ticket: String, publisher: PassthroughSubject<CurrentPrice, Error>)]()
        
        var loadFeedCallCount: Int {
            return requests.count
        }
        
        func loadPublisher(for ticket: String) -> AnyPublisher<CurrentPrice, Error> {
            let publisher = PassthroughSubject<CurrentPrice, Error>()
            requests.append((ticket, publisher))
            return publisher.eraseToAnyPublisher()
        }
        
        func completeCurrentPriceLoadingWithError(at index: Int = 0) {
            requests[index].publisher.send(completion: .failure(anyNSError()))
        }
        
        func completeCurrentPriceLoading(with currentPrice: CurrentPrice, at index: Int = 0) {
            requests[index].publisher.send(currentPrice)
            requests[index].publisher.send(completion: .finished)
        }
    }
}
