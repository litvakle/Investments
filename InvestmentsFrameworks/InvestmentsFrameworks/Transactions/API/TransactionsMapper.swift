//
//  TransactionsMapper.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 12.10.2022.
//

import Foundation

public class TransactionsMapper {
    struct CurrentPriceAPI: Decodable {
        let c: Double
        
        var currentPrice: CurrentPrice {
            CurrentPrice(price: c)
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
        case connectionError
    }
    
    public static var isOK: Int { 200 }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> CurrentPrice {
        guard response.statusCode == isOK else { throw Error.connectionError }
        guard let decoded = try? JSONDecoder().decode(CurrentPriceAPI.self, from: data) else { throw Error.invalidData }
        
        return decoded.currentPrice
    }
}
