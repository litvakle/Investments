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
        let sut = makeSUT(transaction: Transaction())

        sut.quantity = 5
        sut.price = 100
        XCTAssertEqual(sut.sum, 500)

        sut.quantity = 5
        sut.price = 0
        XCTAssertEqual(sut.sum, 0)

        sut.quantity = 0
        sut.price = 500
        XCTAssertEqual(sut.sum, 0)
    }
    
    func test_calcQuantity_calculatesQuantityFromSumAndPrice() {
        let sut = makeSUT(transaction: Transaction())

        sut.price = 100
        sut.sum = 500
        XCTAssertEqual(sut.quantity, 5)

        sut.price = 0
        sut.sum = 500
        XCTAssertEqual(sut.quantity, 0)

        sut.price = 1000
        sut.sum = 0
        XCTAssertEqual(sut.quantity, 0)
    }
    
    func test_checkTicket_validatesTicket() {
        incorrectTickets().forEach { incorrectTicket in
            let sut = makeSUT(transaction: Transaction(ticket: incorrectTicket))
            XCTAssertNil(sut.ticketErrorMessage, "Expected no error messages until check")
            sut.checkTicket()
            XCTAssertNotNil(sut.ticketErrorMessage, "ticket \(incorrectTicket)")
        }

        correctTickets().forEach { correctTicket in
            let sut = makeSUT(transaction: Transaction(ticket: correctTicket))
            sut.checkTicket()
            XCTAssertNil(sut.ticketErrorMessage, "ticket \(correctTicket)")
        }
    }
    
    func test_checkNumberRequisites_validatesNumberRequisites() {
//        incorrectAmounts().forEach { incorrectAmount in
//            let sut = makeSUT(transaction: Transaction(quantity: incorrectAmount, price: incorrectAmount, sum: incorrectAmount))
//
//            XCTAssertNil(sut.quantityErrorMessage, "Expected no error messages until check")
//            XCTAssertNil(sut.priceErrorMessage, "Expected no error messages until check")
//            XCTAssertNil(sut.sumErrorMessage, "Expected no error messages until check")
//            
//            sut.checkPrice()
//            sut.checkQuantity()
//            sut.checkSum()
//            
//            XCTAssertNotNil(sut.quantityErrorMessage, "amount \(incorrectAmount)")
//            XCTAssertNotNil(sut.priceErrorMessage, "amount \(incorrectAmount)")
//            XCTAssertNotNil(sut.sumErrorMessage, "amount \(incorrectAmount)")
//        }
//
//        correctAmounts().forEach { correctAmount in
//            let sut = makeSUT(transaction: Transaction(quantity: correctAmount, price: correctAmount, sum: correctAmount))
//            
//            sut.checkPrice()
//            sut.checkQuantity()
//            sut.checkSum()
//
//            XCTAssertNil(sut.quantityErrorMessage, "amount \(correctAmount)")
//            XCTAssertNil(sut.priceErrorMessage, "amount \(correctAmount)")
//            XCTAssertNil(sut.sumErrorMessage, "amount \(correctAmount)")
//        }
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
