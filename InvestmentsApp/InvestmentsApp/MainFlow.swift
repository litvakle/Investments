//
//  MainFlow.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 20.09.2022.
//

import Combine
import InvestmentsFrameworks
import SwiftUI

class MainFlow: ObservableObject {
    @Published var navigationState = NavigationState()
    @Published var selectedTransaction: InvestmentTransaction?
    
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
    
    func showTransactionsView(transactionsViewModel: TransactionsViewModel) -> some View {
        let destination = makeTransactionView(
            transaction: selectedTransaction,
            onSave: { [weak self] transactionToSave in
                transactionsViewModel.save(transactionToSave)
                self?.navigationState.deactivate()
            }
        )
        let navigationLink = ActivatableNavigationLink(state: navigationState) {
            destination
        }

        let view = makeTransactionsView(transactionsViewModel: transactionsViewModel)
        return VStack {
            view
            navigationLink
        }
    }
    
    private func makeTransactionsView(transactionsViewModel: TransactionsViewModel) -> TransactionsView {
        var view = TransactionsView(viewModel: transactionsViewModel)
        view.onTransactionSelect = { [weak self] transactionToSelect in
            self?.selectedTransaction = transactionToSelect
            self?.navigationState.activate()
        }
        view.onTransactionDelete = transactionsViewModel.delete
        
        return view
    }
    
    private func makeTransactionView(
        transaction: InvestmentTransaction?,
        onSave: @escaping (InvestmentTransaction) -> Void
    ) -> TransactionView {
        let viewModel = TransactionViewModel(
            transaction: transaction ?? Transaction(),
            onSave: onSave
        )
        
        return TransactionView(viewModel)
    }
}
