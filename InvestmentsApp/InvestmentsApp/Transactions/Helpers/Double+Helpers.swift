//
//  Double+Helpers.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 15.09.2022.
//

import Foundation

extension Double {
    func asCurrencyString() -> String {
        return String(format: "%.2f", self)
    }
}
