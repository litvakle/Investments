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
    
    func test_calcSum_calculatesSumFromQuantityAndPrice() {
        let transaction = Transaction()
        let sut = makeSUT(transaction: transaction)

        sut.quantity = 5
        sut.price = 100
        sut.calcSum()
        XCTAssertEqual(sut.sum, 500)

        sut.quantity = 5
        sut.price = 0
        sut.calcSum()
        XCTAssertEqual(sut.sum, 0)

        sut.quantity = 0
        sut.price = 100
        sut.calcSum()
        XCTAssertEqual(sut.sum, 0)
    }
    
    func test_calcQuantity_calculatesQuantityFromSumAndPrice() {
        let transaction = Transaction()
        let sut = makeSUT(transaction: transaction)

        sut.price = 100
        sut.sum = 500
        sut.calcQuantity()
        XCTAssertEqual(sut.quantity, 5)

        sut.price = 0
        sut.sum = 500
        sut.calcQuantity()
        XCTAssertEqual(sut.quantity, 0)

        sut.price = 1000
        sut.sum = 0
        sut.calcQuantity()
        XCTAssertEqual(sut.quantity, 0)
    }
    
    func test_checkErrors_detectsErrorsInRequisites() {
        let transaction = Transaction(date: Date(), ticket: "", type: .buy, quantity: 0, price: 0, sum: 0)
        let sut = makeSUT(transaction: transaction)

        XCTAssertNil(sut.ticketErrorMessage, "Expected no error messages until check")
        XCTAssertNil(sut.quantityErrorMessage, "Expected no error messages until check")
        XCTAssertNil(sut.priceErrorMessage, "Expected no error messages until check")
        XCTAssertNil(sut.sumErrorMessage, "Expected no error messages until check")
        
        incorrectTickets().forEach { incorrectTicket in
            sut.ticket = incorrectTicket
            sut.checkTicket()
            XCTAssertNotNil(sut.ticketErrorMessage, "ticket \(incorrectTicket)")
        }

        correctTickets().forEach { correctTicket in
            sut.ticket = correctTicket
            sut.checkTicket()
            XCTAssertNil(sut.ticketErrorMessage, "ticket \(correctTicket)")
        }

        incorrectAmounts().forEach { incorrectAmount in
            sut.price = incorrectAmount
            sut.quantity = incorrectAmount
            sut.sum = incorrectAmount

            sut.checkPrice()
            sut.checkQuantity()
            sut.checkSum()
            
            XCTAssertNotNil(sut.quantityErrorMessage, "amount \(incorrectAmount)")
            XCTAssertNotNil(sut.priceErrorMessage, "amount \(incorrectAmount)")
            XCTAssertNotNil(sut.sumErrorMessage, "amount \(incorrectAmount)")
        }

        correctAmounts().forEach { correctAmount in
            sut.price = correctAmount
            sut.quantity = correctAmount
            sut.sum = correctAmount
            
            sut.checkPrice()
            sut.checkQuantity()
            sut.checkSum()

            XCTAssertNil(sut.quantityErrorMessage, "amount \(correctAmount)")
            XCTAssertNil(sut.priceErrorMessage, "amount \(correctAmount)")
            XCTAssertNil(sut.sumErrorMessage, "amount \(correctAmount)")
        }
    }
    
    func test_save_invokesOnlyIfThereAreNoErrors() {
        let transaction = Transaction()
        var saveInvokesCount = 0
        let sut = makeSUT(transaction: transaction) { _ in
            saveInvokesCount += 1
        }
        
        sut.save()
        XCTAssertEqual(saveInvokesCount, 0)
        
        sut.ticket = incorrectTickets()[0]
        sut.quantity = incorrectAmounts()[0]
        sut.price = incorrectAmounts()[0]
        sut.sum = incorrectAmounts()[0]

        sut.save()
        XCTAssertEqual(saveInvokesCount, 0)
        
        sut.ticket = correctTickets()[0]
        sut.quantity = correctAmounts()[0]
        sut.price = correctAmounts()[0]
        sut.sum = correctAmounts()[0]
        
        sut.save()
        XCTAssertEqual(saveInvokesCount, 1)
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
