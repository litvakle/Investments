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

func currentPriceLoader() -> AnyPublisher<CurrentPrice, Error> {
    PassthroughSubject<CurrentPrice, Error>().eraseToAnyPublisher()
}

@main
struct InvestmentsAppApp: App {
    @StateObject var transactionsViewModel = TransactionsViewModelFactory.createViewModel(store: TransactionsStoreFactory.create())
    @StateObject var alertViewModel = AlertViewModel()
    @StateObject var mainFlow = MainFlow()
    @StateObject var portfolioFlow = PortfolioFlow()
    @StateObject var portfolioViewModel = PortfolioViewModel()
    @StateObject var currentPricesViewModel = CurrentPricesViewModel(loader: currentPriceLoader)
    @StateObject var currentPricesFlow = CurrentPricesFlow()
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                transactionsViewModel: transactionsViewModel,
                portfolioViewModel: portfolioViewModel,
                currentPricesViewModel: currentPricesViewModel,
                alertViewModel: alertViewModel,
                mainFlow: mainFlow,
                portfolioFlow: portfolioFlow,
                currentPricesFlow: currentPricesFlow)
        }
    }
}
