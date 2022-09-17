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
    
    @Published private(set) public var priceErrorMessage: String?
    @Published private(set) public var ticketErrorMessage: String?
    @Published private(set) public var quantityErrorMessage: String?
    @Published private(set) public var sumErrorMessage: String?
    
    private var onSave: (Transaction) -> Void
    
    var cancellables = Set<AnyCancellable>()
    
    public init(transaction: Transaction, onSave: @escaping (Transaction) -> Void) {
        self.id = transaction.id
        self.date = transaction.date
        self.type = transaction.type
        self.ticket = transaction.ticket
        self.quantity = transaction.quantity
        self.price = transaction.price
        self.sum = transaction.sum
        self.onSave = onSave
        
        Publishers.CombineLatest($quantity, $sum)
            .map { $0 == 0 ? 0 : $1 / $0 }
            .assign(to: &$price)
        
        $ticket
            .dropFirst()
            .map { [weak self] in
                self?.isCorrect($0) == true ? nil : "Ticket should contain 3 or 4 letters"
            }
            .assign(to: &$ticketErrorMessage)
    }
    
    public func save() {
        checkEveryrhing()
        guard everythingIsCorrect() else { return }
        
        onSave(Transaction(id: id, date: date, ticket: ticket, type: type, quantity: quantity, price: price, sum: sum))
    }
    
    public func calcSum() {
        sum = quantity * price
    }
    
    public func calcQuantity() {
        quantity = (price > 0 ? sum / price : 0)
    }
}

//MARK: - Validation

extension TransactionViewModel {
    private func isCorrect(_ ticket: String) -> Bool {
        guard ticket.count == 3 || ticket.count == 4 else { return false }
        
        for char in ticket {
            if !char.isLetter { return false }
        }
        
        return true
    }
    
    public func checkQuantity() {
        quantityErrorMessage = quantity > 0 ? nil : "Quantity should be greater than zero"
    }
    
    public func checkPrice() {
        priceErrorMessage = price > 0 ? nil : "Price should be greater than zero"
    }
    
    public func checkSum() {
        sumErrorMessage = sum > 0 ? nil : "Sum should be greater than zero"
    }
    
    private func checkEveryrhing() {
        checkQuantity()
        checkPrice()
        checkSum()
    }
    
    private func everythingIsCorrect() -> Bool {
        ticketErrorMessage == nil && quantityErrorMessage == nil && priceErrorMessage == nil && sumErrorMessage == nil
    }
}
