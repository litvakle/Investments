//
//  CurrentPricesFlow.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 30.09.2022.
//

import Combine
import InvestmentsFrameworks

public class CurrentPricesFlow: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    
    init() {}
    
    public func setupSubscriptions(currentPricesViewModel: CurrentPricesViewModel, transactionsViewModel: TransactionsViewModel) {
        transactionsViewModel.$transactions
            .map { updatedTransactions in
                let ticketsInUpdatedTransactions = Set(updatedTransactions.map { $0.ticket })
                let ticketsInExistingTransactions = Set(transactionsViewModel.transactions.map { $0.ticket })
                return Array(ticketsInUpdatedTransactions.subtracting(ticketsInExistingTransactions))
            }
            .sink { tickets in
                currentPricesViewModel.loadPrices(for: tickets)
            }
            .store(in: &cancellables)
    }
}
