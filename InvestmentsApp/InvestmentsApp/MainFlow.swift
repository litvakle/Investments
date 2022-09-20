//
//  MainFlow.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 20.09.2022.
//

import Combine
import InvestmentsFrameworks

class MainFlow: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    
    func subscribeTo(transactionsViewModel: TransactionsViewModel, alertViewModel: AlertViewModel) {
        transactionsViewModel.$error
            .dropFirst()
            .map { $0 != nil }
            .sink { showError in
                alertViewModel.showAlert(title: "Error", message: "Error in storage operation")
            }
            .store(in: &cancellables)
    }
}
