//
//  PortfolioFlow.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 27.09.2022.
//

import Foundation
import Combine
import InvestmentsFrameworks
import SwiftUI

class PortfolioFlow: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    
    init() {}
    
    func setupSubscriptions(portfolioViewModel: PortfolioViewModel, transactionsViewModel: TransactionsViewModel, currentPricesViewModel: CurrentPricesViewModel) {
        Publishers.CombineLatest(transactionsViewModel.$transactions, currentPricesViewModel.$currentPrices)
            .sink { transactions, currentPrices in
                portfolioViewModel.calcPortfolio(for: transactions, with: currentPrices)
            }
            .store(in: &cancellables)
    }
    
    func showPortfolioView(
        portfolioViewModel: PortfolioViewModel,
        currentPricesViewModel: CurrentPricesViewModel
    ) -> some View {
        return PortfolioView(
            viewModel: portfolioViewModel,
            isLoading: currentPricesViewModel.isLoading,
            onRefresh: currentPricesViewModel.refreshPrices
        )
    }
}
