//
//  ContentView.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 21.09.2022.
//

import SwiftUI
import InvestmentsFrameworks

struct ContentView: View {
    @ObservedObject var transactionsViewModel: TransactionsViewModel
    @ObservedObject var alertViewModel: AlertViewModel
    @ObservedObject var mainFlow: MainFlow
    
    var body: some View {
        NavigationView {
            TransactionsViewFactory.createView(viewModel: transactionsViewModel)
        }
        .alert(isPresented: $alertViewModel.isActive) {
            Alert(
                title: Text(alertViewModel.title),
                message: Text(alertViewModel.message)
            )
        }
        .onAppear {
            mainFlow.subscribeTo(
                transactionsViewModel: transactionsViewModel,
                alertViewModel: alertViewModel
            )
        }
    }
}
