//
//  TransactionViewModelTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 15.09.2022.
//

import XCTest
import InvestmentsFrameworks
import Combine

class TransactionViewModel: ObservableObject {
    @Published private(set) var id: UUID
    @Published var date: Date
    @Published var type: TransactionType
    @Published var ticket: String
    @Published var quantity: Double
    @Published var price: Double
    @Published var sum: Double
    
    @Published private(set) var ticketErrorMessage: String?
    @Published private(set) var quantityErrorMessage: String?
    @Published private(set) var priceErrorMessage: String?
    @Published private(set) var sumErrorMessage: String?
    
    init(transaction: Transaction) {
        self.id = transaction.id
        self.date = transaction.date
        self.type = transaction.type
        self.ticket = transaction.ticket
        self.quantity = transaction.quantity
        self.price = transaction.price
        self.sum = transaction.sum
        
        setupSubsriptions()
    }
    
    private func setupSubsriptions() {
        $ticket
            .dropFirst()
            .map { [weak self] ticket in
                self?.isCorrect(ticket: ticket) == true ? nil : "Ticket should contain 3 or 4 letters"
            }
            .assign(to: &$ticketErrorMessage)
        
        $quantity
            .dropFirst()
            .map { $0 <= 0 ? "Quantity should be below than zero" : nil }
            .assign(to: &$quantityErrorMessage)
        
        $price
            .dropFirst()
            .map { $0 <= 0 ? "Price should be below than zero" : nil }
            .assign(to: &$priceErrorMessage)
        
        $sum
            .dropFirst()
            .map { $0 <= 0 ? "Sum should be below than zero" : nil }
            .assign(to: &$sumErrorMessage)
    }
    
    private func isCorrect(ticket: String) -> Bool {
        guard ticket.count == 3 || ticket.count == 4 else { return false }
        
        for char in ticket {
            if !char.isLetter { return false }
        }
        
        return true
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
    
    func test_changeRequisites_leadsToChecksErrors() {
        let transaction = Transaction(date: Date(), ticket: "", type: .buy, quantity: 0, price: 0, sum: 0)
        let sut = makeSUT(transaction: transaction)
        
        XCTAssertNil(sut.ticketErrorMessage, "Expected no error messages until start editing")
        XCTAssertNil(sut.quantityErrorMessage, "Expected no error messages until start editing")
        XCTAssertNil(sut.priceErrorMessage, "Expected no error messages until start editing")
        XCTAssertNil(sut.sumErrorMessage, "Expected no error messages until start editing")
        
        incorrectTickets().forEach { incorrectTicket in
            sut.ticket = incorrectTicket
            XCTAssertNotNil(sut.ticketErrorMessage, "ticket \(incorrectTicket)")
        }
        
        correctTickets().forEach { correctTicket in
            sut.ticket = correctTicket
            XCTAssertNil(sut.ticketErrorMessage, "ticket \(correctTicket)")
        }
        
        incorrectAmounts().forEach { incorrectAmount in
            sut.price = incorrectAmount
            sut.quantity = incorrectAmount
            sut.sum = incorrectAmount
            
            XCTAssertNotNil(sut.quantityErrorMessage, "amount \(incorrectAmount)")
            XCTAssertNotNil(sut.priceErrorMessage, "amount \(incorrectAmount)")
            XCTAssertNotNil(sut.sumErrorMessage, "amount \(incorrectAmount)")
        }
        
        correctAmounts().forEach { correctAmount in
            sut.price = correctAmount
            sut.quantity = correctAmount
            sut.sum = correctAmount
            
            XCTAssertNil(sut.quantityErrorMessage, "amount \(correctAmount)")
            XCTAssertNil(sut.priceErrorMessage, "amount \(correctAmount)")
            XCTAssertNil(sut.sumErrorMessage, "amount \(correctAmount)")
        }
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
    
    private func incorrectTickets() -> [String] {
        ["", "A", "AA", "A A", "AA0", "-RT"]
    }
    
    private func correctTickets() -> [String] {
        ["AAA", "BBB", "aaa"]
    }
    
    private func incorrectAmounts() -> [Double] {
        [0, -0.0001, -1, -100]
    }
    
    private func correctAmounts() -> [Double] {
        [0.0001, 1, 100]
    }
}
