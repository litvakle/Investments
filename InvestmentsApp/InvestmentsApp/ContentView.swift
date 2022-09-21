//
//  ContentView.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 21.09.2022.
//

import SwiftUI
import InvestmentsFrameworks

struct ContentView: View {
    @StateObject var transactionsViewModel: TransactionsViewModel
    @StateObject var alertViewModel = AlertViewModel()
    @StateObject var mainFlow = MainFlow()
    
    init(store: TransactionsStore) {
        _transactionsViewModel = StateObject(wrappedValue: TransactionsViewModelFactory.createViewModel(store: store))
    }
    
    var body: some View {
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
