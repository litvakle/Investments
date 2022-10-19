//
//  ContentView.swift
//  InvestmentsWatchOS WatchKit Extension
//
//  Created by Lev Litvak on 11.10.2022.
//

import SwiftUI
import InvestmentsFrameworks

struct ContentView: View {
    @ObservedObject var transactionsViewModel: TransactionsViewModel
    @ObservedObject var portfolioViewModel: PortfolioViewModel
    @ObservedObject var currentPricesViewModel: CurrentPricesViewModel
    @ObservedObject var alertViewModel: AlertViewModel
   
    let transactionsFlow: TransactionsFlow
    let portfolioFlow: PortfolioFlow
    let currentPricesFlow: CurrentPricesFlow
    
    var body: some View {
        PortfolioView(
            cost: portfolioViewModel.summary.cost,
            profit: portfolioViewModel.summary.profit,
            profitPercent: portfolioViewModel.summary.profitPercent,
            isLoading: transactionsViewModel.isRetrieving || currentPricesViewModel.isLoading,
            onRefresh: transactionsViewModel.retrieve
        )
        .alert(alertViewModel.title, isPresented: $alertViewModel.isActive, actions: {
            Button("OK", action: {})
        }, message: {
            Text(alertViewModel.message)
        })
        
    }
}
