//
//  TransactionsView.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 15.09.2022.
//

import SwiftUI
import InvestmentsFrameworks

struct TransactionsView: View {
    @ObservedObject private(set) var vm: TransactionsViewModel
    
    var body: some View {
        NavigationView {
            TransactionsList(transactions: vm.transactions, onDeleteTransaction: vm.delete)
                .navigationTitle("Transactions")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TransactionsList(transactions: [
                InvestmentTransaction(date: Date(), ticket: "VOO", type: .buy, quantity: 2, price: 200, sum: 400),
                InvestmentTransaction(date: Date(), ticket: "QQQ", type: .sell, quantity: 1.5, price: 100, sum: 150)
            ], onDeleteTransaction: { _ in })
            .navigationTitle("Transactions")
        }
    }
}
