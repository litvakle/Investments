//
//  PortfolioFlow.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 27.09.2022.
//

import Foundation
import Combine
import InvestmentsFrameworks

class PortfolioFlow: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    
    init() {}
    
    func setupSubscriptions(portfolioViewModel: PortfolioViewModel, transactionsViewModel: TransactionsViewModel) {
        transactionsViewModel.$transactions
            .removeDuplicates()
            .sink { transactions in
                portfolioViewModel.createItems(for: transactions, with: CurrentPrices())
            }
            .store(in: &cancellables)
    }
}
