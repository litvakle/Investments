//
//  TransactionsFlow.swift
//  InvestmentsWatchOS WatchKit Extension
//
//  Created by Lev Litvak on 18.10.2022.
//

import Combine
import InvestmentsFrameworksWatchOS

class TransactionsFlow {
    private var cancellables = Set<AnyCancellable>()
    
    func setupSubscriptions(transactionsViewModel: TransactionsViewModel, alertViewModel: AlertViewModel) {
        transactionsViewModel.$error
            .filter { $0 != nil }
            .sink { errorMessage in
                alertViewModel.showAlert(title: "Error", message: "Error loading transactions")
            }
            .store(in: &cancellables)
    }
}
