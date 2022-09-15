//
//  TransactionViewModelTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 15.09.2022.
//

import XCTest
import InvestmentsFrameworks

class TransactionViewModel: ObservableObject {
    @Published private(set) var id: UUID
    @Published private(set) var date: Date
    @Published private(set) var type: TransactionType
    @Published private(set) var ticket: String
    @Published private(set) var quantity: Double
    @Published private(set) var price: Double
    @Published private(set) var sum: Double
    
    init(transaction: Transaction) {
        self.id = transaction.id
        self.date = transaction.date
        self.type = transaction.type
        self.ticket = transaction.ticket
        self.quantity = transaction.quantity
        self.price = transaction.price
        self.sum = transaction.sum
    }
}

class TransactionViewModelTests: XCTestCase {
    func test_init_fillsViewModelRequisites() {
        let transaction = makeTransaction()
        let sut = makeSUT(transaction: transaction)
        
        XCTAssertEqual(sut.id, transaction.id)
        XCTAssertEqual(sut.date, transaction.date)
        XCTAssertEqual(sut.type, transaction.type)
        XCTAssertEqual(sut.ticket, transaction.ticket)
        XCTAssertEqual(sut.quantity, transaction.quantity)
        XCTAssertEqual(sut.price, transaction.price)
        XCTAssertEqual(sut.sum, transaction.sum)
    }
    
    // MARK: - Helpers
    private func makeSUT(
        transaction: Transaction,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> TransactionViewModel {
        let sut = TransactionViewModel(transaction: transaction)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
