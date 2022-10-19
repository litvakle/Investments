//
//  UIComposer.swift
//  InvestmentsWatchOS WatchKit Extension
//
//  Created by Lev Litvak on 18.10.2022.
//

import Foundation
import InvestmentsFrameworksWatchOS

class UIComposer {
    var transactionsViewModel: TransactionsViewModel
    var alertViewModel = AlertViewModel()
    var portfolioViewModel = PortfolioViewModel()
    var currentPricesViewModel: CurrentPricesViewModel
    var transactionsFlow = TransactionsFlow()
    var portfolioFlow = PortfolioFlow()
    var currentPricesFlow = CurrentPricesFlow()
    
    init(
        httpClient: HTTPClient,
        currentPricesBaseURL: URL,
        currentPricesToken: String,
        transactionsProjectID: String
    ) {
        let transactionsLoaderFactory = TransactionsLoaderFactory(
            httpClient: httpClient, projectID: transactionsProjectID
        )
        transactionsViewModel = TransactionsViewModel(
            retriever: transactionsLoaderFactory.makeRemoteTransactionsLoader, saver: .none, deleter: .none
        )
        
        let currentPriceLoaderFactory = CurrentPriceLoaderFactory(
            httpClient: httpClient, baseURL: currentPricesBaseURL, token: currentPricesToken
        )
        currentPricesViewModel = CurrentPricesViewModel(
            loader: currentPriceLoaderFactory.makeRemoteCurrentPriceLoader
        )
        
        transactionsFlow.setupSubscriptions(
            transactionsViewModel: transactionsViewModel, alertViewModel: alertViewModel
        )
        currentPricesFlow.setupSubscriptions(
            currentPricesViewModel: currentPricesViewModel, alertViewModel: alertViewModel
        )
        currentPricesFlow.setupSubscriptions(
            transactionsViewModel: transactionsViewModel, currentPricesViewModel: currentPricesViewModel
        )
        portfolioFlow.setupSubscriptions(
            portfolioViewModel: portfolioViewModel,
            transactionsViewModel: transactionsViewModel,
            currentPricesViewModel: currentPricesViewModel
        )
        
        transactionsViewModel.retrieve()
    }
}
