//
//  InvestmentsWatchOSApp.swift
//  InvestmentsWatchOS WatchKit Extension
//
//  Created by Lev Litvak on 11.10.2022.
//

import InvestmentsFrameworks
import SwiftUI

@main
struct InvestmentsWatchOSApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(viewModel: TransactionsViewModel(store: NullStore()))
            }
        }
    }
}
