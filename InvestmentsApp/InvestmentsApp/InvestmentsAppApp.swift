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

@main
struct InvestmentsAppApp: App {
    @StateObject var transactionsViewModel = TransactionsViewModelFactory.createViewModel(store: TransactionsStoreFactory.create())
    @StateObject var alertViewModel = AlertViewModel()
    @StateObject var mainFlow = MainFlow()
    @StateObject var portfolioFlow = PortfolioFlow()
    @StateObject var portfolioViewModel = PortfolioViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                transactionsViewModel: transactionsViewModel,
                portfolioViewModel: portfolioViewModel,
                alertViewModel: alertViewModel,
                mainFlow: mainFlow,
                portfolioFlow: portfolioFlow)
        }
    }
}
