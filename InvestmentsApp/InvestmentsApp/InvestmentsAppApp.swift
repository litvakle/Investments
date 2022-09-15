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
            TransactionsView(vm: transactionsViewModel)
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
