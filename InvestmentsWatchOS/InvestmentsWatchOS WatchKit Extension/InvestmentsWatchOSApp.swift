//
//  InvestmentsWatchOSApp.swift
//  InvestmentsWatchOS WatchKit Extension
//
//  Created by Lev Litvak on 11.10.2022.
//

import SwiftUI
import InvestmentsFrameworks

typealias InvestmentTransaction = InvestmentsFrameworks.Transaction

private let root = UIComposer(
    httpClient: URLSessionHTTPClient(session: URLSession(configuration: .ephemeral)),
    currentPricesBaseURL: URL(string: "https://finnhub.io/api")!,
    currentPricesToken: "ccfe31iad3ifmhk0t53g",
    transactionsProjectID: "investments-3b67e-default-rtdb"
)

@main
struct InvestmentsWatchOSApp: App {
    @StateObject var transactionsViewModel = root.transactionsViewModel
    @StateObject var alertViewModel = root.alertViewModel
    @StateObject var portfolioViewModel = root.portfolioViewModel
    @StateObject var currentPricesViewModel = root.currentPricesViewModel
    
    let transactionsFlow = root.transactionsFlow
    let portfolioFlow = root.portfolioFlow
    let currentPricesFlow = root.currentPricesFlow
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
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
}
