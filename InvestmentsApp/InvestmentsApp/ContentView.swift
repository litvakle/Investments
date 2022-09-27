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
    @ObservedObject var portfolioViewModel: PortfolioViewModel
    @ObservedObject var alertViewModel: AlertViewModel
    @ObservedObject var mainFlow: MainFlow
    @ObservedObject var portfolioFlow: PortfolioFlow
    
    var body: some View {
        TabView {
            PortfolioView(viewModel: portfolioViewModel)
                .tabItem {
                    Text("Portf")
                }
            
            NavigationView {
                mainFlow.showTransactionsView(transactionsViewModel: transactionsViewModel)
            }.tabItem {
                Text("Trans")
            }
        }
        .alert(alertViewModel.title, isPresented: $alertViewModel.isActive, actions: {
            Button("OK", action: {})
        }, message: {
            Text(alertViewModel.message)
        })
        .accessibilityIdentifier("MAIN_TAB_VIEW")
        .onAppear {
            mainFlow.setupSubscriptions(
                transactionsViewModel: transactionsViewModel,
                alertViewModel: alertViewModel
            )
            portfolioFlow.setupSubscriptions(
                portfolioViewModel: portfolioViewModel,
                transactionsViewModel: transactionsViewModel
            )
        }
    }
}