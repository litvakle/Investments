//
//  TransactionViewModelTests.swift
//  InvestmentsFrameworksTests
//
//  Created by Lev Litvak on 15.09.2022.
//

import XCTest
import InvestmentsFrameworks
import Combine

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
    
    func test_save_invokesOnlyIfThereAreNoErrors() {
        let transaction = makeTransaction()
        var savedTransactions = [Transaction]()
        let sut = makeSUT(transaction: transaction) { transactionToSave in
            savedTransactions.append(transactionToSave)
        }
        
        sut.ticket = incorrectTickets()[0]
        sut.save()
        XCTAssertEqual(savedTransactions, [])
        
        sut.ticket = transaction.ticket
        sut.save()
        XCTAssertEqual(savedTransactions, [transaction])
    }
    
    // MARK: - Helpers
    private func makeSUT(
        transaction: Transaction,
        onSave: @escaping (Transaction) -> Void = { _ in },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> TransactionViewModel {
        let sut = TransactionViewModel(transaction: transaction, onSave: onSave)
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
