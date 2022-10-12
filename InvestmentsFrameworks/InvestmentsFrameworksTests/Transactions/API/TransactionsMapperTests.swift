//
//  TransactionsMapperTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 12.10.2022.
//

import XCTest
import Foundation
import InvestmentsFrameworks

class TransactionsMapperTests: XCTestCase {
    func test_map_throwsConnectionErrorOnNon200HTTPResponse() throws {
        let json = makeJSON([[:]])
        let samples = [199, 201, 300, 400, 500]

        samples.forEach { code in
            do {
                _ = try TransactionsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            } catch {
                XCTAssertEqual(error as! TransactionsMapper.Error, TransactionsMapper.Error.connectionError)
            }
        }
    }
    
    func test_map_throwsInvalidDataErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)

        do {
            _ = try TransactionsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        } catch {
            XCTAssertEqual(error as! TransactionsMapper.Error, TransactionsMapper.Error.invalidData)
        }
    }
    
    func test_map_deliversTransactionsOn200HTTPResponseWithCorrectJSON() throws {
        let item1 = makeItem(
            id: UUID(),
            date: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"),
            ticket: "AAA",
            type: .buy,
            quantity: 10,
            price: 20,
            sum: 200
        )
    
        let item2 = makeItem(
            id: UUID(),
            date: (Date(timeIntervalSince1970: 1577881882), "2020-01-01T12:31:22+00:00"),
            ticket: "BBB",
            type: .sell,
            quantity: 5,
            price: 10,
            sum: 50
        )
        
        let json = makeJSON([item1.json, item2.json])
        
        let result = try TransactionsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    // MARK: - Helpers
    
    func makeJSON(_ data: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: data)
    }
    
    private func makeItem(id: UUID, date: (date: Date, iso8601String: String), ticket: String, type: TransactionType, quantity: Double, price: Double, sum: Double) -> (model: Transaction, json: [String: Any]) {
        let item = Transaction(id: id, date: date.date, ticket: ticket, type: type, quantity: quantity, price: price, sum: sum)
        
        let json: [String: Any] = [
            "id": id.uuidString,
            "date": date.iso8601String,
            "ticket": ticket,
            "type": type.asString(),
            "quantity": quantity,
            "price": price,
            "sum": sum
        ]
        
        return (item, json)
    }
}
