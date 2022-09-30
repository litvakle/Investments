//
//  NumberFormatter+Currency.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 16.09.2022.
//

import Foundation

public extension NumberFormatter {
    static func currencyFormatter(
        minFractionDigits: Int = 0,
        maxFractionDigits: Int = 0,
        currencyCode: String,
        locale: Locale = .current
    ) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.locale = locale
        formatter.minimumFractionDigits = minFractionDigits
        formatter.maximumFractionDigits = maxFractionDigits
        
        return formatter
    }
    
    static func decimalFormatter(
        minFractionDigits: Int = 0,
        maxFractionDigits: Int = 0,
        locale: Locale
    ) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        formatter.minimumFractionDigits = minFractionDigits
        formatter.maximumFractionDigits = maxFractionDigits
        
        return formatter
    }
    
    static func percentFormatter(
        minFractionDigits: Int = 0,
        maxFractionDigits: Int = 0,
        locale: Locale
    ) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.locale = locale
        formatter.minimumFractionDigits = minFractionDigits
        formatter.maximumFractionDigits = maxFractionDigits
        
        return formatter
    }
}
