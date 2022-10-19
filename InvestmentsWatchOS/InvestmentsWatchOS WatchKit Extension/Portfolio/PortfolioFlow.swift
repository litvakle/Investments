//
//  PortfolioFlow.swift
//  InvestmentsWatchOS WatchKit Extension
//
//  Created by Lev Litvak on 18.10.2022.
//

import Combine
import InvestmentsFrameworks

class PortfolioFlow {
    var cancellables = Set<AnyCancellable>()
    
    func setupSubscriptions(portfolioViewModel: PortfolioViewModel, transactionsViewModel: TransactionsViewModel, currentPricesViewModel: CurrentPricesViewModel) {
        Publishers.CombineLatest(transactionsViewModel.$transactions, currentPricesViewModel.$currentPrices)
            .dispatchOnMainQueue()
            .sink { (transactions, currentPrices) in
                portfolioViewModel.calcPortfolio(for: transactions, with: currentPrices)
            }
            .store(in: &cancellables)
    }
}
