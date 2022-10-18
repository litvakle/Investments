//
//  ContentView.swift
//  InvestmentsWatchOS WatchKit Extension
//
//  Created by Lev Litvak on 11.10.2022.
//

import SwiftUI
import InvestmentsFrameworks

struct ContentView: View {
    private let viewModel: TransactionsViewModel
    
    init(viewModel: TransactionsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text("Hello, World!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: TransactionsViewModel(store: NullStore()))
    }
}
