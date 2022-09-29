//
//  CurrentPriceViewModelTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 28.09.2022.
//

import XCTest
import Combine
import InvestmentsFrameworks

class CurrentPriceViewModel: ObservableObject {
    @Published var currentPrices = [String: CurrentPrice]()
    @Published var loadingTickets = Set<String>()
    @Published var error: String?

    let loader: () -> AnyPublisher<CurrentPrice, Error>
    var cancellables = Set<AnyCancellable>()
    
    init(loader: @escaping () -> AnyPublisher<CurrentPrice, Error>) {
        self.loader = loader
    }
    
    func loadPrices(for tickets: [String]) {
        error = nil
        
        tickets.forEach { [weak self] ticket in
            self?.loadingTickets.insert(ticket)
            loader()
                .sink { completion in
                    if case .failure = completion {
                        self?.error = "Error loading prices"
                    }
                    self?.loadingTickets.remove(ticket)
                } receiveValue: { price in
                    self?.currentPrices[ticket] = price
                }
                .store(in: &cancellables)
        }
    }
}

class CurrentPriceViewModelTests: XCTestCase {
    func test_init_doesNotRequestLoader() {
        let (_, loader) = makeSUT()
        
        XCTAssertTrue(loader.requests.isEmpty)
    }
    
    func test_loadPrices_requestsLoader() {
        let (sut, loader) = makeSUT()
        let tickets0 = ["AAA", "BBB"]
        let tickets1 = ["CCC"]
        
        sut.loadPrices(for: tickets0)
        sut.loadPrices(for: tickets1)
        
        XCTAssertEqual(loader.requests.count, 3)
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
    
    func test_loadPrices_makesLoadingIndicatorsForEachTicketOnAtStartAndOffAfterLoading() {
        let (sut, loader) = makeSUT()
        let tickets = ["AAA", "BBB", "CCC"]
        
        sut.loadPrices(for: tickets)
        XCTAssertEqual(sut.loadingTickets, ["AAA", "BBB", "CCC"])
        
        loader.completeCurrentPriceLoading(with: CurrentPrice(price: 100), at: 1)
        XCTAssertEqual(sut.loadingTickets, ["AAA", "CCC"])
        
        loader.completeCurrentPriceLoadingWithError(at: 2)
        XCTAssertEqual(sut.loadingTickets, ["AAA"])
        
        loader.completeCurrentPriceLoading(with: CurrentPrice(price: 100), at: 0)
        XCTAssertEqual(sut.loadingTickets, [])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (CurrentPriceViewModel, LoaderSpy) {
        let loader = LoaderSpy()
        let sut = CurrentPriceViewModel(loader: loader.loadPublisher)
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader)
    }
    
    private class LoaderSpy {
        var requests = [PassthroughSubject<CurrentPrice, Error>]()
        
        var loadFeedCallCount: Int {
            return requests.count
        }
        
        func loadPublisher() -> AnyPublisher<CurrentPrice, Error> {
            let publisher = PassthroughSubject<CurrentPrice, Error>()
            requests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeCurrentPriceLoadingWithError(at index: Int = 0) {
            requests[index].send(completion: .failure(anyNSError()))
        }
        
        func completeCurrentPriceLoading(with currentPrice: CurrentPrice, at index: Int = 0) {
            requests[index].send(currentPrice)
            requests[index].send(completion: .finished)
        }
    }
}
