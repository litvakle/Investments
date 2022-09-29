//
//  PortfolioTestHelpers.swift
//  InvestmentsAppTests
//
//  Created by Lev Litvak on 26.09.2022.
//

import InvestmentsFrameworks

public func makePortfolioTransactions() -> [Transaction] {
    [
        Transaction(ticket: "BBB", type: .buy, quantity: 1, price: 10, sum: 10),
        Transaction(ticket: "AAA", type: .buy, quantity: 1, price: 10, sum: 10),
        Transaction(ticket: "AAA", type: .buy, quantity: 2, price: 20, sum: 40),
        Transaction(ticket: "AAA", type: .buy, quantity: 3, price: 30, sum: 90),
        Transaction(ticket: "BBB", type: .buy, quantity: 2, price: 20, sum: 40),
        Transaction(ticket: "BBB", type: .sell, quantity: 1, price: 25, sum: 25),
        Transaction(ticket: "CCC", type: .buy, quantity: 1, price: 30, sum: 30)
    ]
}

public func makeCurrentPrices() -> CurrentPrices {
    [
        "AAA": CurrentPrice(price: 35),
        "BBB": CurrentPrice(price: 30)
    ]
}

public func makePortfolioItems(with currentPrices: CurrentPrices = CurrentPrices()) -> [PortfolioItem] {
    [
        PortfolioItem(ticket: "AAA", quantity: 6, price: 35, cost: 210, expenses: 140, income: 0, profit: 70, profitPercent: 0.5),
        PortfolioItem(ticket: "BBB", quantity: 2, price: 30, cost: 60, expenses: 50, income: 25, profit: 35, profitPercent: 0.7),
        PortfolioItem(ticket: "CCC", quantity: 1, price: 0, cost: 0, expenses: 30, income: 0, profit: -30, profitPercent: -1)
    ]
}
