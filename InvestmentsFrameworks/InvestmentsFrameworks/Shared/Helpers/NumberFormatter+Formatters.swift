//
//  NumberFormatter+Currency.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 16.09.2022.
//

import Foundation

public extension NumberFormatter {
    static func currencyFormatter(
        fractionDigits: Int,
        currencyCode: String,
        locale: Locale = .current
    ) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.locale = locale
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        
        return formatter
    }
    
    static func decimalFormatter(fractionDigits: Int, locale: Locale) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        
        return formatter
    }
}