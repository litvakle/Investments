//
//  TransactionsLoaderFactory.swift
//  InvestmentsWatchOS WatchKit Extension
//
//  Created by Lev Litvak on 18.10.2022.
//

import Combine
import InvestmentsFrameworks

class TransactionsLoaderFactory {
    let httpClient: HTTPClient
    let projectID: String
    
    init(httpClient: HTTPClient, projectID: String) {
        self.httpClient = httpClient
        self.projectID = projectID
    }
    
    func makeRemoteTransactionsLoader() -> AnyPublisher<[Transaction], Error> {
        let url = TransactionsEndPoint.get.url(projectID: projectID)
        
        return httpClient
            .getPublisher(url: url)
            .tryMap(TransactionsMapper.map)
            .eraseToAnyPublisher()
    }
}
