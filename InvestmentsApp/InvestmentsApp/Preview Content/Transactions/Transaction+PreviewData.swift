//
//  PreviewProvider+Transactions.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 15.09.2022.
//

import Foundation
import SwiftUI

extension InvestmentTransaction {
    static var previewData: [InvestmentTransaction] {
        [
            InvestmentTransaction(date: Date(), ticket: "VOO", type: .buy, quantity: 2, price: 200, sum: 400),
            InvestmentTransaction(date: Date(), ticket: "QQQ", type: .sell, quantity: 1.5, price: 100, sum: 150)
        ]
    }
}
