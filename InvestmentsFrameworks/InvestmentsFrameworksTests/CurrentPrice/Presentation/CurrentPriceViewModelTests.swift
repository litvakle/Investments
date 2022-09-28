//
//  CurrentPriceViewModelTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 28.09.2022.
//

import XCTest

protocol CurrentPriceLoader {
    func loadPrice(for ticket: String)
}

class CurrentPriceViewModel: ObservableObject {
    let loader: CurrentPriceLoader
    
    init(loader: CurrentPriceLoader) {
        self.loader = loader
    }
    
    func loadPrices(for tickets: [String]) {
        tickets.forEach { loader.loadPrice(for: $0) }
    }
}

class CurrentPriceViewModelTests: XCTestCase {
    func test_init_doesNotRequestLoader() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.requested, [])
    }
    
    func test_loadPrices_requestsLoader() {
        let (sut, loader) = makeSUT()
        let tickets0 = ["AAA", "BBB"]
        let tickets1 = ["CCC"]
        
        sut.loadPrices(for: tickets0)
        sut.loadPrices(for: tickets1)
        
        XCTAssertEqual(loader.requested, [tickets0[0], tickets0[1], tickets1[0]])
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
        var requested = [String]()
        
        func loadPrice(for ticket: String) {
            requested.append(ticket)
        }
    }
}


