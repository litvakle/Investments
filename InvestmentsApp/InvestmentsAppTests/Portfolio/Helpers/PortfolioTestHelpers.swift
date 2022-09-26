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
        Transaction(ticket: "AAA", type: .buy, quantity: 2, price: 20, sum: 20),
        Transaction(ticket: "AAA", type: .buy, quantity: 3, price: 10, sum: 30),
        Transaction(ticket: "BBB", type: .buy, quantity: 2, price: 20, sum: 20)
    ]
}

public func makePortfolioItems() -> [PortfolioItem] {
    [
        PortfolioItem(ticket: "AAA", quantity: 6, sum: 60),
        PortfolioItem(ticket: "BBB", quantity: 3, sum: 30)
    ]
}
