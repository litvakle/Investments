//
//  TransactionsList.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 15.09.2022.
//

import SwiftUI
import InvestmentsFrameworks

struct TransactionsList: View {
    var transactions: [InvestmentTransaction]
    var onDeleteTransaction: (InvestmentTransaction) -> Void
    var onSaveTransaction: (InvestmentTransaction) -> Void
    
    var body: some View {
        List {
            ForEach(transactions) { transaction in
                NavigationLink {
                    TransactionView(TransactionViewModel(transaction: transaction, onSave: onSaveTransaction))
                } label: {
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
                    }
                }
            }
            .onDelete(perform: delete)
        }
    }
    
    private func delete(indexSet: IndexSet) {
        if let index = indexSet.first {
            onDeleteTransaction(transactions[index])
        }
    }
}

struct TransactionsList_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsList(transactions: PreviewData.transactions, onDeleteTransaction: { _ in }, onSaveTransaction: { _ in })
    }
}
