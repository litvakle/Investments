//
//  SharedTransactionsHelpers.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 14.09.2022.
//

import Foundation
import InvestmentsFrameworks

func makeTransaction() -> Transaction {
    return makeTransactions()[0]
}

func makeTransactions() -> [Transaction] {
    return [
        Transaction(date: Date(), ticket: "VOO", type: .buy, quantity: 2, price: 250, sum: 500),
        Transaction(date: Date(), ticket: "QQQ", type: .sell, quantity: 1.5, price: 100, sum: 150)
    ]
}
