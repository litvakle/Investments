//
//  CurrencyFormatterTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 16.09.2022.
//

import XCTest

class NumberFormatterTests: XCTestCase {
    func test_currencyFormatter_makesCorrectStrings() {
        let sut = NumberFormatter.currencyFormatter(
            minFractionDigits: 2,
            maxFractionDigits: 4,
            currencyCode: "USD",
            locale: Locale(identifier: "en_US_POSIX")
        )
        
        XCTAssertEqual(sut.string(from: NSNumber(value: 0)), "$ 0.00")
        XCTAssertEqual(sut.string(from: NSNumber(value: 1)), "$ 1.00")
        XCTAssertEqual(sut.string(from: NSNumber(value: 9.9999)), "$ 9.9999")
        XCTAssertEqual(sut.string(from: NSNumber(value: 9.99991)), "$ 9.9999")
        XCTAssertEqual(sut.string(from: NSNumber(value: 9.99999)), "$ 10.00")
        
        sut.currencyCode = "EUR"
        XCTAssertEqual(sut.string(from: NSNumber(value: 0)), "€ 0.00")
        XCTAssertEqual(sut.string(from: NSNumber(value: 1)), "€ 1.00")
        XCTAssertEqual(sut.string(from: NSNumber(value: 9.9999)), "€ 9.9999")
        XCTAssertEqual(sut.string(from: NSNumber(value: 9.99991)), "€ 9.9999")
        XCTAssertEqual(sut.string(from: NSNumber(value: 9.99999)), "€ 10.00")
    }
    
    func test_decimalFormatter_makesCorrectStrings() {
        let sut = NumberFormatter.decimalFormatter(
            minFractionDigits: 2,
            maxFractionDigits: 4,
            locale: Locale(identifier: "en_US_POSIX")
        )
        
        XCTAssertEqual(sut.string(from: NSNumber(value: 0)), "0.00")
        XCTAssertEqual(sut.string(from: NSNumber(value: 1)), "1.00")
        XCTAssertEqual(sut.string(from: NSNumber(value: 9.9999)), "9.9999")
        XCTAssertEqual(sut.string(from: NSNumber(value: 9.99991)), "9.9999")
        XCTAssertEqual(sut.string(from: NSNumber(value: 9.99999)), "10.00")
    }
}
