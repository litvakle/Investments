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

private var scheduler: AnyDispatchQueueScheduler = DispatchQueue (
    label: "com.litvaklev.infra.queue",
    qos: .userInitiated,
    attributes: .concurrent
).eraseToAnyScheduler()

private let store = StoreFactory.create()
private let root = UIComposer(
    scheduler: scheduler,
    httpClient: URLSessionHTTPClient(session: URLSession(configuration: .ephemeral)),
    transactionsStore: store,
    currentPricesStore: store,
    baseURL: URL(string: "https://finnhub.io/api")!,
    token: "ccfe31iad3ifmhk0t53g",
    transactionsProjectID: "investments-3b67e-default-rtdb"
)

@main
struct InvestmentsApp: App {
    @StateObject var transactionsViewModel = root.transactionsViewModel
    @StateObject var alertViewModel = root.alertViewModel
    @StateObject var transactionsFlow = root.transactionsFlow
    @StateObject var portfolioFlow = root.portfolioFlow
    @StateObject var portfolioViewModel = root.portfolioViewModel
    @StateObject var currentPricesViewModel = root.currentPricesViewModel
    @StateObject var currentPricesFlow = root.currentPricesFlow
    
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
