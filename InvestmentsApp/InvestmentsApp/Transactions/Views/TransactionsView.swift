//
//  TransactionsView.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 15.09.2022.
//

import SwiftUI
import InvestmentsFrameworks

struct TransactionsView: View {
    let transactions: [InvestmentTransaction]
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
            ForEach(transactions) { transaction in
                Button {
                    onTransactionSelect?(transaction)
                } label: {
                    TransactionRow(transaction: transaction)
                }
                .buttonStyle(.plain)
            }
            .accessibilityIdentifier("TRANSACTIONS")
            .onDelete(perform: delete)
        }
        .listStyle(.insetGrouped)
    }
        
    private func delete(indexSet: IndexSet) {
        if let index = indexSet.first {
            onTransactionDelete?(transactions[index])
        }
    }
    
    private var addNewButton: some View {
        Button {
            onTransactionSelect?(.none)
        } label: {
            Image(systemName: "plus")
        }
        .accessibilityIdentifier("ADD_NEW_TRANSACTION")
    }
}

struct TransactionRow: View {
    var transaction: InvestmentTransaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.date.asTransactionsListItem())
                    .accessibilityIdentifier("DATE")
                Text(transaction.ticket)
                    .accessibilityIdentifier("TICKET")
            }
            
            Spacer()

            VStack(alignment: .trailing) {
                Text("\(transaction.quantity.asCurrencyString())")
                    .accessibilityIdentifier("QUANTITY")
                Text("\(transaction.sum.asCurrencyString())")
                    .accessibilityIdentifier("SUM")
            }
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            NavigationView {
                TransactionsView(transactions: InvestmentTransaction.previewData)
            }
            
            NavigationView {
                TransactionsView(transactions: InvestmentTransaction.previewData)
                    .preferredColorScheme(.dark)
            }
        }
        
    }
}
