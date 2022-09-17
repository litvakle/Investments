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
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        Publishers.CombineLatest($quantity, $sum)
            .map { $0 == 0 ? 0 : $1 / $0 }
            .assign(to: &$price)
        
        $ticket
            .dropFirst()
            .sink(receiveValue: { [weak self] ticket in
                self?.checkTicket(ticket)
            })
            .store(in: &cancellables)
        
        $quantity
            .dropFirst()
            .sink(receiveValue: { [weak self] quantity in
                self?.checkQuantity(quantity)
            })
            .store(in: &cancellables)
        
        $sum
            .dropFirst()
            .sink(receiveValue: { [weak self] sum in
                self?.checkSum(sum)
            })
            .store(in: &cancellables)
    }
    
    public func save() {
        checkTicket(ticket)
        checkQuantity(quantity)
        checkSum(sum)
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
    private func checkTicket(_ ticket: String) {
        ticketErrorMessage = isCorrect(ticket) ? nil : "Ticket should contain 3 or 4 letters"
    }
    
    private func isCorrect(_ ticket: String) -> Bool {
        guard ticket.count == 3 || ticket.count == 4 else { return false }
        
        for char in ticket {
            if !char.isLetter { return false }
        }
        
        return true
    }
    
    private func checkQuantity(_ quantity: Double) {
        quantityErrorMessage = quantity > 0 ? nil : "Quantity should be greater than zero"
    }
    
    private func checkSum(_ sum: Double) {
        sumErrorMessage = sum > 0 ? nil : "Sum should be greater than zero"
    }

    private func everythingIsCorrect() -> Bool {
        ticketErrorMessage == nil && quantityErrorMessage == nil && sumErrorMessage == nil
    }
}
