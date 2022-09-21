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
    var body: some Scene {
        WindowGroup {
            ContentView(store: TransactionsStoreFactory.create())
        }
    }
}
