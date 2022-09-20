//
//  InvestmentsAppApp.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 15.09.2022.
//

import SwiftUI
import CoreData
import InvestmentsFrameworks

typealias InvestmentTransaction = InvestmentsFrameworks.Transaction

@main
struct InvestmentsAppApp: App {
    @StateObject var transactionsViewModel = createTransactionsViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TransactionsViewFactory.createView(viewModel: transactionsViewModel)
            }
        }
    }
}

private func createTransactionsViewModel() -> TransactionsViewModel {
    let viewModel = TransactionsViewModel(store: createTransactionsStore())
    viewModel.retrieve()
    
    return viewModel
}

private func createTransactionsStore() -> TransactionsStore {
    return try! CoreDataTransactionsStore(
        storeURL: NSPersistentContainer
            .defaultDirectoryURL()
            .appendingPathComponent("transactions-store.sqlite")
    )
}

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

enum TransactionViewFactory {
    static func createView(
        transaction: InvestmentTransaction,
        onTransactionSave: @escaping (InvestmentTransaction) -> Void
    ) -> some View {
        let viewModel = TransactionViewModel(transaction: transaction, onSave: onTransactionSave)
        return TransactionView(viewModel)
    }
}
