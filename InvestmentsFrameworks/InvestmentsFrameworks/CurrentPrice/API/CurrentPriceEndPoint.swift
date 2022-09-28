//
//  CurrentPriceEndPoint.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 28.09.2022.
//

import Foundation

public enum CurrentPriceEndPoint {
    case get(forTicket: String)
    
    public func url(baseURL: URL, token: String) -> URL {
        switch self {
        case let .get(ticket):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/v1/quote"
            components.queryItems = [
                URLQueryItem(name: "symbol", value: ticket),
                URLQueryItem(name: "token", value: token)
            ]
            return components.url!
        }
    }
}
