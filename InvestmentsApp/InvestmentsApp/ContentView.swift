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
    @ObservedObject var currentPricesViewModel: CurrentPricesViewModel
    @ObservedObject var alertViewModel: AlertViewModel
    @ObservedObject var transactionsFlow: TransactionsFlow
    @ObservedObject var portfolioFlow: PortfolioFlow
    @ObservedObject var currentPricesFlow: CurrentPricesFlow
    var currentPricesLoaderFactory: CurrentPricesLoaderFactory?
    
    var body: some View {
        TabView {
            NavigationView {
                portfolioFlow.showPortfolioView(portfolioViewModel: portfolioViewModel, currentPricesViewModel: currentPricesViewModel)
            }
            .tabItem {
                Image(systemName: "dollarsign.circle")
            }
            
            NavigationView {
                transactionsFlow.showTransactionsView(transactionsViewModel: transactionsViewModel)
            }.tabItem {
                Image(systemName: "list.bullet.circle")
            }
        }
        .alert(alertViewModel.title, isPresented: $alertViewModel.isActive, actions: {
            Button("OK", action: {})
        }, message: {
            Text(alertViewModel.message)
        })
    }
}
