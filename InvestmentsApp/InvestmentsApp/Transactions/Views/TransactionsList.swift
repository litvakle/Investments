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
    var onTransactionSelect: ((InvestmentTransaction) -> Void)?
    var onTransactionDelete: ((InvestmentTransaction) -> Void)?
    
    var body: some View {
        List {
            ForEach(transactions) { transaction in
                Button {
                    onTransactionSelect?(transaction)
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
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .onDelete(perform: delete)
        }
    }
    
    private func delete(indexSet: IndexSet) {
        if let index = indexSet.first {
            onTransactionDelete?(transactions[index])
        }
    }
}

struct TransactionsList_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsList(transactions: PreviewData.transactions)
    }
}
