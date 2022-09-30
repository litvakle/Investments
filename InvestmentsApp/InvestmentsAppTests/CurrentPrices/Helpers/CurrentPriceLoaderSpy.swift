//
//  CurrentPriceLoaderSpy.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 30.09.2022.
//

import InvestmentsFrameworks
import Combine

public class CurrentPriceLoaderSpy {
    public var requests = [PassthroughSubject<CurrentPrice, Error>]()
    
    public var loadFeedCallCount: Int {
        return requests.count
    }
    
    public func loadPublisher() -> AnyPublisher<CurrentPrice, Error> {
        let publisher = PassthroughSubject<CurrentPrice, Error>()
        requests.append(publisher)
        return publisher.eraseToAnyPublisher()
    }
    
    public func completeCurrentPriceLoadingWithError(at index: Int = 0) {
        requests[index].send(completion: .failure(anyNSError()))
    }
    
    public func completeCurrentPriceLoading(with currentPrice: CurrentPrice, at index: Int = 0) {
        requests[index].send(currentPrice)
        requests[index].send(completion: .finished)
    }
}
