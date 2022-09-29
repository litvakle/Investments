//
//  CurrentPriceViewModelTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 28.09.2022.
//

import XCTest
import Combine
import InvestmentsFrameworks

protocol CurrentPriceLoader {
    func loadPrice(for ticket: String)
}

class CurrentPriceViewModel: ObservableObject {
    let loader: () -> AnyPublisher<CurrentPrice, Error>
    
    init(loader: @escaping () -> AnyPublisher<CurrentPrice, Error>) {
        self.loader = loader
    }
    
    func loadPrices(for tickets: [String]) {
        tickets.forEach { ticket in
            _ = loader()
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
    }
}


