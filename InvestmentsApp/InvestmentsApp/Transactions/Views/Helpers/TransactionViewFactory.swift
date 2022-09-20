//
//  TransactionViewFactory.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 20.09.2022.
//

import InvestmentsFrameworks
import SwiftUI

enum TransactionViewFactory {
    static func createView(
        transaction: InvestmentTransaction,
        onTransactionSave: @escaping (InvestmentTransaction) -> Void
    ) -> some View {
        let viewModel = TransactionViewModel(
            transaction: transaction,
            onSave: onTransactionSave
        )
        return TransactionView(viewModel)
    }
}
