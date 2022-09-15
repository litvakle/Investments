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
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            TransactionView(InvestmentTransaction(date: Date(), ticket: "XXX", type: .buy, quantity: 2, price: 200, sum: 400))
                        } label: {
                            Image(systemName: "plus")
                                .padding(.horizontal)
                        }

                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    class PreviewTransactionsStore: TransactionsStore {
        func retrieve() throws -> [InvestmentTransaction] { return PreviewData.transactions }
        func delete(_ transaction: InvestmentTransaction) throws {}
        func save(_ transaction: InvestmentTransaction) throws {}
    }
    
    static var previews: some View {
        let viewModel = TransactionsViewModel(store: PreviewTransactionsStore())
        viewModel.retrieve()
        return TransactionsView(vm: viewModel)
    }
}