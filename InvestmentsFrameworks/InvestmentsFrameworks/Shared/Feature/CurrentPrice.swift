//
//  CurrentPrice.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 27.09.2022.
//

import Foundation

public struct CurrentPrices {
    public let prices: [String: CurrentPrice]
    
    public init(prices: [String: CurrentPrice]) {
        self.prices = prices
    }
}

public struct CurrentPrice: Equatable {
    public let price: Double

    public init(price: Double) {
        self.price = price
    }
}
