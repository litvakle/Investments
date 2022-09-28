//
//  CurrentPriceEndPointTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 28.09.2022.
//

import XCTest
import InvestmentsFrameworks

class CurrentPriceEndPointTests: XCTestCase {
    func test_feed_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!
        let token = "a_token"
        let ticket = "a_ticket"
        
        let received = CurrentPriceEndPoint.get(forTicket: ticket).url(baseURL: baseURL, token: token)
        
        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v1/quote", "path")
        XCTAssertEqual(received.query, "symbol=\(ticket)&token=\(token)", "query")
    }
}
