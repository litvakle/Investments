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
    var onTransactionSelect: ((InvestmentTransaction?) -> Void)?
    
    var body: some View {
        TransactionsList(
            transactions: vm.transactions,
            onTransactionSelect: onTransactionSelect,
            onTransactionDelete: vm.delete)
        .navigationTitle("Transactions")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    onTransactionSelect?(.none)
                } label: {
                    Image(systemName: "plus")
                        .padding(.horizontal)
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
        return Group {
            NavigationView {
                TransactionsView(vm: viewModel)
            }
            
            NavigationView {
                TransactionsView(vm: viewModel)
                    .preferredColorScheme(.dark)
            }
        }
        
    }
}
