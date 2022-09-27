//
//  CurrentPriceMapperTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 27.09.2022.
//

import XCTest
import Foundation

struct CurrentPrice {
    let price: Double
}

class CurrentPriceMapper {
    public enum Error: Swift.Error {
        case invalidData
        case connectionError
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> CurrentPrice {
        throw Error.connectionError
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
