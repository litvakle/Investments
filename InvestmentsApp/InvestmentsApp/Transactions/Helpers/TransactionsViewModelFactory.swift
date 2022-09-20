//
//  TransactionsViewModelFactory.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 20.09.2022.
//

import InvestmentsFrameworks

enum TransactionsViewModelFactory {
    static func createViewModel(store: TransactionsStore) -> TransactionsViewModel {
        let viewModel = TransactionsViewModel(store: store)
        viewModel.retrieve()
        
        return viewModel
    }
}
