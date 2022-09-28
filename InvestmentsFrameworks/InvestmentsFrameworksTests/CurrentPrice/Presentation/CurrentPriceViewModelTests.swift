//
//  CurrentPriceViewModelTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 28.09.2022.
//

import XCTest

protocol CurrentPriceLoader {}

class CurrentPriceViewModel: ObservableObject {
    let loader: CurrentPriceLoader
    
    init(loader: CurrentPriceLoader) {
        self.loader = loader
    }
}

class CurrentPriceViewModelTests: XCTestCase {
    func test_init_doesNotRequestLoader() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.requests, [])
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
            case get(tickets: [String])
        }
    }
}


