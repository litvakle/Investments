//
//  CurrentPricesFlow.swift
//  InvestmentsWatchOS WatchKit Extension
//
//  Created by Lev Litvak on 18.10.2022.
//

import Combine
import InvestmentsFrameworks

class CurrentPricesFlow {
    private var cancellables = Set<AnyCancellable>()
    
    func setupSubscriptions(transactionsViewModel: TransactionsViewModel, currentPricesViewModel: CurrentPricesViewModel) {
        transactionsViewModel.$transactions
            .map { transactions -> [String] in
                let tickets = transactions.map { $0.ticket }
                return Array(Set(tickets))
            }
            .dispatchOnMainQueue()
            .sink { tickets in
                currentPricesViewModel.loadPrices(for: tickets)
            }
            .store(in: &cancellables)
    }
    
    func setupSubscriptions(currentPricesViewModel: CurrentPricesViewModel, alertViewModel: AlertViewModel) {
        currentPricesViewModel.$error
            .filter { $0 != nil }
            .sink { errorMessage in
                alertViewModel.showAlert(title: "Error", message: errorMessage ?? "")
            }
            .store(in: &cancellables)
    }
}
