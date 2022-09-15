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
    
    private var cancellables = Set<AnyCancellable>()
    
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
            .map { $0.count < 3 ? "Ticket should contain at least 3 symbols" : nil }
            .sink { [weak self] message in
                self?.ticketErrorMessage = message
            }
            .store(in: &cancellables)
        
        $quantity
            .map { $0 <= 0 ? "Quantity should be below than zero" : nil }
            .sink { [weak self] message in
                self?.quantityErrorMessage = message
            }
            .store(in: &cancellables)
        
        $price
            .map { $0 <= 0 ? "Price should be below than zero" : nil }
            .sink { [weak self] message in
                self?.priceErrorMessage = message
            }
            .store(in: &cancellables)
        
        $sum
            .map { $0 <= 0 ? "Sum should be below than zero" : nil }
            .sink { [weak self] message in
                self?.sumErrorMessage = message
            }
            .store(in: &cancellables)
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
    
    func test_editRequisites_affectsOnCorrectionChecking() {
        let transaction = makeTransaction()
        let sut = makeSUT(transaction: transaction)
        
        sut.ticket = ""
        XCTAssertNotNil(sut.ticketErrorMessage)
        
        sut.quantity = 0
        XCTAssertNotNil(sut.quantityErrorMessage)
        
        sut.quantity = -1
        XCTAssertNotNil(sut.quantityErrorMessage)
        
        sut.price = 0
        XCTAssertNotNil(sut.priceErrorMessage)
        
        sut.price = -1
        XCTAssertNotNil(sut.priceErrorMessage)
        
        sut.sum = 0
        XCTAssertNotNil(sut.sumErrorMessage)
        
        sut.sum = -1
        XCTAssertNotNil(sut.sumErrorMessage)
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
