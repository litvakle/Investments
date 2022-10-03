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
    private let httpClient: HTTPClient
    private var baseURL: URL
    private var token: String
    private var store: CurrentPricesStore
    
    init(httpClient: HTTPClient, baseURL: URL, token: String, store: CurrentPricesStore) {
        self.httpClient = httpClient
        self.baseURL = baseURL
        self.token = token
        self.store = store
    }
    
    func makeRemoteCurrentPriceLoader(for ticket: String) -> AnyPublisher<CurrentPrice, Error> {
        let url = CurrentPriceEndPoint.get(forTicket: ticket).url(baseURL: baseURL, token: token)

        return httpClient
            .getPublisher(url: url)
            .tryMap(CurrentPriceMapper.map)
            .eraseToAnyPublisher()
    }
}
