//
//  CurrentPricesLoaderFactory.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 03.10.2022.
//

import Foundation
import Combine
import InvestmentsFrameworks

class CurrentPricesLoaderFactory {
    private let scheduler: AnyDispatchQueueScheduler
    private let httpClient: HTTPClient
    private let baseURL: URL
    private let token: String
    private let store: CurrentPricesStore
    var onRemoteLoaderError: (() -> Void)?
    
    init(scheduler: AnyDispatchQueueScheduler, httpClient: HTTPClient, baseURL: URL, token: String, store: CurrentPricesStore) {
        self.scheduler = scheduler
        self.httpClient = httpClient
        self.baseURL = baseURL
        self.token = token
        self.store = store
    }
    
    func makeRemoteCurrentPriceLoaderWithLocalFeedback(for ticket: String) -> AnyPublisher<CurrentPrice, Error> {
        makeRemoteCurrentPriceLoader(for: ticket)
            .caching(to: store, for: ticket)
            .subscribe(on: scheduler)
            .dispatchOnMainQueue()
            .fallback(to: { [weak self, store] in
                self?.onRemoteLoaderError?()
                return store.loadCurrentPricePublisher(for: ticket)
            })
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteCurrentPriceLoader(for ticket: String) -> AnyPublisher<CurrentPrice, Error> {
        let url = CurrentPriceEndPoint.get(forTicket: ticket).url(baseURL: baseURL, token: token)

        return httpClient
            .getPublisher(url: url)
            .tryMap(CurrentPriceMapper.map)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
}
