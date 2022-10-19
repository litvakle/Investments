//
//  CurrentPriceLoaderFactory.swift
//  InvestmentsWatchOS WatchKit Extension
//
//  Created by Lev Litvak on 18.10.2022.
//

import Combine
import InvestmentsFrameworks

class CurrentPriceLoaderFactory {
    let httpClient: HTTPClient
    let baseURL: URL
    let token: String
    
    init(httpClient: HTTPClient, baseURL: URL, token: String) {
        self.httpClient = httpClient
        self.baseURL = baseURL
        self.token = token
    }
    
    func makeRemoteCurrentPriceLoader(for ticket: String) -> AnyPublisher<CurrentPrice, Error> {
        let url = CurrentPriceEndPoint.get(forTicket: ticket).url(baseURL: baseURL, token: token)
        
        return httpClient
            .getPublisher(url: url)
            .tryMap(CurrentPriceMapper.map)
            .eraseToAnyPublisher()
    }
}
