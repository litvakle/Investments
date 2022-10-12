//
//  TransactionsEndPoint.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 12.10.2022.
//

import Foundation

public enum TransactionsEndPoint {
    case get
    
    public func url(projectID: String) -> URL {
        switch self {
        case .get:
            var components = URLComponents()
            components.scheme = "https"
            components.host = "\(projectID).firebaseio.com"
            components.path = "/transactions.json"

            return components.url!
        }
    }
}
