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
    
    func test_quantityAndSumChange_leadsToCalcPriceForNewTransactions() {
        let sut = makeSUT(transaction: Transaction())

        sut.quantity = 100
        sut.sum = 500
        XCTAssertEqual(sut.price, 5)

        sut.quantity = 0
        sut.sum = 500
        XCTAssertEqual(sut.price, 0)

        sut.quantity = 1000
        sut.sum = 0
        XCTAssertEqual(sut.price, 0)
    }
    
    func test_quantityAndSumChange_leadsToCalcPriceForExistingTransactions() {
        let sut0 = makeSUT(transaction: Transaction(quantity: 100))
        let sut1 = makeSUT(transaction: Transaction(sum: 1000))
        
        sut0.sum = 500
        XCTAssertEqual(sut0.price, 5)

        sut1.quantity = 10
        XCTAssertEqual(sut1.price, 100)
    }
    
    func test_init_DoesNotValidateRequisitesForNewTransactions() {
        let sut = makeSUT(transaction: Transaction())
        
        XCTAssertNil(sut.ticketErrorMessage, "Expected no error messages until check")
        XCTAssertNil(sut.quantityErrorMessage, "Expected no error messages until check")
        XCTAssertNil(sut.sumErrorMessage, "Expected no error messages until check")
    }
    
    func test_checkTicket_validatesTicket() {
        let sut = makeSUT(transaction: Transaction())

        incorrectTickets().forEach { incorrectTicket in
            sut.ticket = incorrectTicket
            XCTAssertNotNil(sut.ticketErrorMessage, "ticket \(incorrectTicket)")
        }

        correctTickets().forEach { correctTicket in
            sut.ticket = correctTicket
            XCTAssertNil(sut.ticketErrorMessage, "ticket \(correctTicket)")
        }
    }
    
    func test_checkNumberRequisites_validatesNumberRequisites() {
        let sut = makeSUT(transaction: Transaction())

        incorrectAmounts().forEach { incorrectAmount in
            sut.quantity = incorrectAmount
            XCTAssertNotNil(sut.quantityErrorMessage, "amount \(incorrectAmount)")

            sut.sum = incorrectAmount
            XCTAssertNotNil(sut.sumErrorMessage, "amount \(incorrectAmount)")
        }

        correctAmounts().forEach { correctAmount in
            sut.quantity = correctAmount
            XCTAssertNil(sut.quantityErrorMessage, "amount \(correctAmount)")

            sut.sum = correctAmount
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
