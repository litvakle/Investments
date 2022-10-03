//
//  CombineHelpers.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 03.10.2022.
//

import Foundation
import Combine
import InvestmentsFrameworks

public extension CurrentPricesStore {
    typealias Publisher = AnyPublisher<Data, Error>
    
    func loadCurrentPricePublisher(for ticket: String) -> AnyPublisher<CurrentPrice, Error> {
        return Deferred {
            Future { completion in
                completion(Result {
                    try self.retrieve(for: ticket) ?? CurrentPrice(price: 0)
                })
            }
        }
        .eraseToAnyPublisher()
    }
}

extension Publisher where Output == CurrentPrice {
    func caching(to cache: CurrentPricesStore, for ticket: String) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: { currentPrice in
            cache.saveIgnoringResult(currentPrice, for: ticket)
        }).eraseToAnyPublisher()
    }
}

private extension CurrentPricesStore {
    func saveIgnoringResult(_ currentPrice: CurrentPrice, for ticket: String) {
        try? save(currentPrice, for: ticket)
    }
}

extension Publisher {
    func fallback(to fallbackPublisher: @escaping () -> AnyPublisher<Output, Failure>) -> AnyPublisher<Output, Failure> {
        self.catch { _ in fallbackPublisher() }.eraseToAnyPublisher()
    }
}

public extension HTTPClient {
    typealias Publisher = AnyPublisher<(Data, HTTPURLResponse), Error>
    
    func getPublisher(url: URL) -> Publisher {
        var task: HTTPClientTask?
        
        return Deferred {
            Future { completion in
                task = self.get(from: url, completion: completion)
            }
        }
        .handleEvents(receiveCancel: { task?.cancel() })
        .eraseToAnyPublisher()
    }
}
