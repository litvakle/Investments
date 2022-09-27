//
//  CurrentPriceMapperTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 27.09.2022.
//

import XCTest
import Foundation

struct CurrentPrice: Equatable {
    let price: Double
}

class CurrentPriceMapper {
    struct CurrentPriceAPI: Decodable {
        let c: Double
        
        var currentPrice: CurrentPrice {
            CurrentPrice(price: c)
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
        case connectionError
    }
    
    static var isOK: Int { 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> CurrentPrice {
        guard response.statusCode == isOK else { throw Error.connectionError }
        guard let decoded = try? JSONDecoder().decode(CurrentPriceAPI.self, from: data) else { throw Error.invalidData }
        
        return decoded.currentPrice
    }
}

class CurrentPriceMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeJSON([:])
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try CurrentPriceMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try CurrentPriceMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
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
