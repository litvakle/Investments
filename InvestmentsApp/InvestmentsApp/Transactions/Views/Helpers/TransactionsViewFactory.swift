//
//  TransactionsViewFactory.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 20.09.2022.
//

import SwiftUI
import InvestmentsFrameworks

enum TransactionsViewFactory {
    static func createView(viewModel: TransactionsViewModel) -> some View {
        var transaction: InvestmentTransaction?
        let navigationState = NavigationState()
        let navigationLink = ActivatableNavigationLink(state: navigationState) {
            TransactionViewFactory.createView(
                transaction: transaction ?? InvestmentTransaction(),
                onTransactionSave: { transaction in
                    viewModel.save(transaction)
                    navigationState.deactivate()
                }
            )
        }
        
        var view = TransactionsView(viewModel: viewModel)
        view.onTransactionSelect = { selectedTransaction in
            transaction = selectedTransaction
            navigationState.activate()
        }
        view.onTransactionDelete = viewModel.delete

        return VStack {
            view
            navigationLink
        }
    }
}
