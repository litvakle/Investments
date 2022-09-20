//
//  InvestmentsAppApp.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 15.09.2022.
//

import SwiftUI
import CoreData
import InvestmentsFrameworks
import Combine

typealias InvestmentTransaction = InvestmentsFrameworks.Transaction

private var transactionsStore: TransactionsStore = {
    do {
        return try CoreDataTransactionsStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("transactions-store.sqlite")
            )
    } catch {
        return NullTransactionsStore()
    }
}()

@main
struct InvestmentsAppApp: App {
    @StateObject var transactionsViewModel = TransactionsViewModelFactory.createViewModel(store: transactionsStore)
    @StateObject var alertViewModel = AlertViewModel()
    @StateObject var mainFlow = MainFlow()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TransactionsViewFactory.createView(viewModel: transactionsViewModel)
            }
            .onAppear {
                mainFlow.subscribeTo(
                    transactionsViewModel: transactionsViewModel,
                    alertViewModel: alertViewModel
                )
            }
            .alert(isPresented: $alertViewModel.isActive) {
                Alert(
                    title: Text(alertViewModel.title),
                    message: Text(alertViewModel.message)
                )
            }
        }
    }
}
