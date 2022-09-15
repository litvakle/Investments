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
    
    public func save() {
        guard everythingIsCorrect() else { return }
        
        onSave(Transaction(id: id, date: date, ticket: ticket, type: type, quantity: quantity, price: price, sum: sum))
    }
    
    private func everythingIsCorrect() -> Bool {
        ticketErrorMessage == nil && priceErrorMessage == nil && quantityErrorMessage == nil && sumErrorMessage == nil
    }
}
