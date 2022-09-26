//
//  PortfolioTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 26.09.2022.
//

import XCTest
import InvestmentsFrameworks

class PortfolioViewModel {
    var items = [PortfolioItem]()
    
    func createItems(for transactions: [Transaction]) {
        var totalData = [String: (quantity: Double, sum: Double)]()
        transactions.forEach { transaction in
            let quantity = totalData[transaction.ticket]?.quantity ?? 0
            let sum = totalData[transaction.ticket]?.sum ?? 0
            totalData[transaction.ticket] = (quantity + transaction.quantity, sum + transaction.sum)
        }
        
        items = totalData.map { PortfolioItem(ticket: $0.key, quantity: $0.value.quantity, sum: $0.value.sum)}
            .sorted(by: { $0.ticket < $1.ticket })
    }
}

struct PortfolioItem: Equatable {
    let ticket: String
    let quantity: Double
    let sum: Double
}

class PortfolioTests: XCTestCase {
    func test_createItems_calculatesTotalParametersForAllTickets() {
        let sut = PortfolioViewModel()
        let transactions = [
            Transaction(ticket: "BBB", type: .buy, quantity: 1, price: 10, sum: 10),
            Transaction(ticket: "AAA", type: .buy, quantity: 1, price: 10, sum: 10),
            Transaction(ticket: "AAA", type: .buy, quantity: 2, price: 20, sum: 20),
            Transaction(ticket: "AAA", type: .buy, quantity: 3, price: 10, sum: 30),
            Transaction(ticket: "BBB", type: .buy, quantity: 2, price: 20, sum: 20)
        ]
        let expectedItem0 = PortfolioItem(ticket: "AAA", quantity: 6, sum: 60)
        let expectedItem1 = PortfolioItem(ticket: "BBB", quantity: 3, sum: 30)
        
        sut.createItems(for: transactions)
        
        XCTAssertEqual(sut.items, [expectedItem0, expectedItem1])
    }
}
