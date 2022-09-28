//
//  CurrentPriceViewModelTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 28.09.2022.
//

import XCTest

protocol CurrentPriceLoader {
    func load(forTickets tickets: [String])
}

class CurrentPriceViewModel: ObservableObject {
    let loader: CurrentPriceLoader
    
    init(loader: CurrentPriceLoader) {
        self.loader = loader
    }
    
    func loadPrices(forTickets tickets: [String]) {
        loader.load(forTickets: tickets)
    }
}

class CurrentPriceViewModelTests: XCTestCase {
    func test_init_doesNotRequestLoader() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.requests, [])
    }
    
    func test_loadPrices_requestsLoader() {
        let (sut, loader) = makeSUT()
        let tickets0 = ["AAA", "BBB"]
        let tickets1 = ["CCC"]
        
        sut.loadPrices(forTickets: tickets0)
        sut.loadPrices(forTickets: tickets1)
        
        XCTAssertEqual(loader.requests, [.get(tickets0), .get(tickets1)])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (CurrentPriceViewModel, LoaderSpy) {
        let loader = LoaderSpy()
        let sut = CurrentPriceViewModel(loader: loader)
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader)
    }
    
    private class LoaderSpy: CurrentPriceLoader {
        var requests = [Request]()
        
        enum Request: Equatable {
            case get(_ tickets: [String])
        }
        
        func load(forTickets tickets: [String]) {
            requests.append(.get(tickets))
        }
    }
}


