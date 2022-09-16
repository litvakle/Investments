//
//  CurrencyFormatterTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 16.09.2022.
//

import XCTest

extension NumberFormatter {
    static func currencyFormatter(
        fractionDigits: Int,
        currencyCode: String,
        locale: Locale = .current
    ) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.locale = locale
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        
        return formatter
    }
}

class CurrencyFormatterTests: XCTestCase {
    func test_currencyFormatter_makesCorrectStrings() {
        let sut = NumberFormatter.currencyFormatter(
            fractionDigits: 4,
            currencyCode: "USD",
            locale: Locale(identifier: "en_US_POSIX")
        )
        
        XCTAssertEqual(sut.string(from: NSNumber(value: 0)), "")
        XCTAssertEqual(sut.string(from: NSNumber(value: 1)), "$ 1.0000")
        XCTAssertEqual(sut.string(from: NSNumber(value: 9.9999)), "$ 9.9999")
        XCTAssertEqual(sut.string(from: NSNumber(value: 9.99991)), "$ 9.9999")
        XCTAssertEqual(sut.string(from: NSNumber(value: 9.99999)), "$ 10.0000")
        
        sut.currencyCode = "EUR"
        XCTAssertEqual(sut.string(from: NSNumber(value: 0)), "")
        XCTAssertEqual(sut.string(from: NSNumber(value: 1)), "€ 1.0000")
        XCTAssertEqual(sut.string(from: NSNumber(value: 9.9999)), "€ 9.9999")
        XCTAssertEqual(sut.string(from: NSNumber(value: 9.99991)), "€ 9.9999")
        XCTAssertEqual(sut.string(from: NSNumber(value: 9.99999)), "€ 10.0000")
    }
}
