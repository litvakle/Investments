//
//  TransactionsEndPointTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 12.10.2022.
//

import XCTest
import InvestmentsFrameworks

class TransactionsEndPointTests: XCTestCase {
    func test_transactions_getEndpointURL() {
        let projectID = "projectID"
        
        let received = TransactionsEndPoint.get.url(projectID: projectID)
        
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "projectID.firebaseio.com", "host")
        XCTAssertEqual(received.path, "/transactions.json", "path")
    }
}
