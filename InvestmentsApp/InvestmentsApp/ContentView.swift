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
            mainFlow.showTransactionsView(transactionsViewModel: transactionsViewModel)
        }
        .alert(alertViewModel.title, isPresented: $alertViewModel.isActive, actions: {
            Button("OK", action: {})
        }, message: {
            Text(alertViewModel.message)
        })
        .onAppear {
            mainFlow.subscribeTo(
                transactionsViewModel: transactionsViewModel,
                alertViewModel: alertViewModel
            )
        }
    }
}
