//
//  TransactionsView.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 15.09.2022.
//

import SwiftUI
import InvestmentsFrameworks


struct TransactionsView: View {
    var viewModel: TransactionsViewModel
    var onTransactionSelect: ((InvestmentTransaction?) -> Void)?
    var onTransactionDelete: ((InvestmentTransaction) -> Void)?
    
    var body: some View {
        transactionsList
        .navigationTitle("Transactions")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                addNewButton
            }
        }
    }
    
    private var transactionsList: some View {
        List {
            ForEach(viewModel.transactions) { transaction in
                Button {
                    onTransactionSelect?(transaction)
                } label: {
                    TransactionRow(transaction: transaction)
                }
                .buttonStyle(.plain)
            }
            .onDelete(perform: delete)
        }
    }
        
    private func delete(indexSet: IndexSet) {
        if let index = indexSet.first {
            onTransactionDelete?(viewModel.transactions[index])
        }
    }
    
    private var addNewButton: some View {
        Button {
            onTransactionSelect?(.none)
        } label: {
            Image(systemName: "plus")
                .padding(.horizontal)
        }
    }
}

struct TransactionRow: View {
    var transaction: InvestmentTransaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.date.asTransactionsListItem())
                Text(transaction.ticket)
            }
            
            Spacer()

            VStack(alignment: .trailing) {
                Text("\(transaction.quantity.asCurrencyString())")
                Text("\(transaction.sum.asCurrencyString())")
            }
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
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
                TransactionsView(viewModel: viewModel)
            }
            
            NavigationView {
                TransactionsView(viewModel: viewModel)
                    .preferredColorScheme(.dark)
            }
        }
        
    }
}
