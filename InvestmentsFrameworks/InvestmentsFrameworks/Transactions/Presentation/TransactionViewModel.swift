//
//  TransactionViewModel.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 15.09.2022.
//

import Foundation
import Combine

public class TransactionViewModel: ObservableObject {
    @Published private(set) public var id: UUID
    @Published public var date: Date
    @Published public var type: TransactionType
    @Published public var ticket: String
    @Published public var quantity: Double
    @Published public var price: Double
    @Published public var sum: Double
    
    @Published private(set) public var ticketErrorMessage: String?
    @Published private(set) public var quantityErrorMessage: String?
    @Published private(set) public var priceErrorMessage: String?
    @Published private(set) public var sumErrorMessage: String?
    
    private var onSave: (Transaction) -> Void
    
    public init(transaction: Transaction, onSave: @escaping (Transaction) -> Void) {
        self.id = transaction.id
        self.date = transaction.date
        self.type = transaction.type
        self.ticket = transaction.ticket
        self.quantity = transaction.quantity
        self.price = transaction.price
        self.sum = transaction.sum
        self.onSave = onSave
        
        setupSubsriptions()
    }
    
    private func setupSubsriptions() {
        $quantity
            .combineLatest($price)
            .map { $0 * $1 }
            .assign(to: &$sum)
        
//        $sum
//            .dropFirst()
//            .map { [weak self] sum in
//                self?.isCorrect(amount: sum) == true ? nil : "Sum should be greater than zero"
//            }
//            .assign(to: &$sumErrorMessage)
    }
    
    func checkTicket() {
        ticketErrorMessage = ticketIsCorrect() ? nil : "Ticket should contain 3 or 4 letters"
    }
    
    private func ticketIsCorrect() -> Bool {
        guard ticket.count == 3 || ticket.count == 4 else { return false }
        
        for char in ticket {
            if !char.isLetter { return false }
        }
        
        return true
    }
    
    func checkQuantity() {
        quantityErrorMessage = quantity > 0 ? nil : "Quantity should be greater than zero"
    }
    
    func checkPrice() {
        priceErrorMessage = price > 0 ? nil : "Price should be greater than zero"
    }
    
    func checkSum() {
        sumErrorMessage = sum > 0 ? nil : "Sum should be greater than zero"
    }
    
    private func isCorrect(amount: Double) -> Bool {
        return amount > 0
    }
    
    public func save() {
        guard everythingIsCorrect() else { return }
        
        onSave(Transaction(id: id, date: date, ticket: ticket, type: type, quantity: quantity, price: price, sum: sum))
    }
    
    private func everythingIsCorrect() -> Bool {
        ticketIsCorrect() && isCorrect(amount: quantity) && isCorrect(amount: price) && isCorrect(amount: sum)
    }
}
