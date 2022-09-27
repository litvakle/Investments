//
//  CurrentPriceMapperTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 27.09.2022.
//

import XCTest
import Foundation
import InvestmentsFrameworks

class CurrentPriceMapperTests: XCTestCase {
    func test_map_throwsConnectionErrorOnNon200HTTPResponse() throws {
        let json = makeJSON([:])
        let samples = [199, 201, 300, 400, 500]

        samples.forEach { code in
            do {
                _ = try CurrentPriceMapper.map(json, from: HTTPURLResponse(statusCode: code))
            } catch {
                XCTAssertEqual(error as! CurrentPriceMapper.Error, CurrentPriceMapper.Error.connectionError)
            }
        }
    }
    
    func test_map_throwsInvalidDataErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)

        do {
            _ = try CurrentPriceMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        } catch {
            XCTAssertEqual(error as! CurrentPriceMapper.Error, CurrentPriceMapper.Error.invalidData)
        }
    }
    
    func test_map_deliversCurrentPriceOn200HTTPResponseWithCorrectJSON() throws {
        let currentPrice = CurrentPrice(price: 100.00)
        let json = makeJSON(["c": 100.00])
        
        let result = try CurrentPriceMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, currentPrice)
    }
    
    // MARK: - Helpers
    
    func makeJSON(_ data: [String: Any]) -> Data {
        return try! JSONSerialization.data(withJSONObject: data)
    }
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
