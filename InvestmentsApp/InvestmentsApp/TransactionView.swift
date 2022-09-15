//
//  TransactionView.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 15.09.2022.
//

import SwiftUI
import InvestmentsFrameworks

struct TransactionView: View {
    var transaction: InvestmentTransaction
    
    
    init(_ transaction: InvestmentTransaction) {
        self.transaction = transaction
    }
    var body: some View {
        Text(transaction.ticket)
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(InvestmentTransaction(date: Date(), ticket: "VOO", type: .buy, quantity: 2, price: 100, sum: 200))
    }
}
