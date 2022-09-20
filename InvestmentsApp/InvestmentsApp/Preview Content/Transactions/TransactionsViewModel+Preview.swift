//
//  TransactionsViewModel+Preview.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 20.09.2022.
//

import Foundation
import InvestmentsFrameworks

private class PreviewTransactionsStore: TransactionsStore {
    func retrieve() throws -> [InvestmentTransaction] { return InvestmentTransaction.previewData }
    func delete(_ transaction: InvestmentTransaction) throws {}
    func save(_ transaction: InvestmentTransaction) throws {}
}

extension TransactionsViewModel {
    static func previewModel() -> TransactionsViewModel {
        let store = PreviewTransactionsStore()
        let viewModel = TransactionsViewModel(store: store)
        viewModel.retrieve()
        
        return viewModel
    }
}
