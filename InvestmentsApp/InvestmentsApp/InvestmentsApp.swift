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
private let httpClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
private let baseURL = URL(string: "https://finnhub.io/api")!
private let token = "ccfe31iad3ifmhk0t53g"
private let store = StoreFactory.create()
private let currentPriceLoader = CurrentPricesLoaderFactory(httpClient: httpClient, baseURL: baseURL, token: token, store: store).makeRemoteCurrentPriceLoaderWithLocalFeedback

@main
struct InvestmentsApp: App {
    @StateObject var transactionsViewModel = TransactionsViewModel(store: store)
    @StateObject var alertViewModel = AlertViewModel()
    @StateObject var transactionsFlow = TransactionsFlow()
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
                transactionsFlow: transactionsFlow,
                portfolioFlow: portfolioFlow,
                currentPricesFlow: currentPricesFlow
            )
        }
    }
}
