//
//  UIComposer.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 05.10.2022.
//

import Foundation
import InvestmentsFrameworks

class UIComposer {
    var transactionsViewModel: TransactionsViewModel
    var alertViewModel = AlertViewModel()
    var transactionsFlow = TransactionsFlow()
    var portfolioFlow = PortfolioFlow()
    var portfolioViewModel = PortfolioViewModel()
    var currentPricesViewModel: CurrentPricesViewModel
    var currentPricesFlow = CurrentPricesFlow()
    
    init(
        httpClient: HTTPClient,
        transactionsStore: TransactionsStore,
        currentPricesStore: CurrentPricesStore,
        baseURL: URL,
        token: String,
        transactionsProjectID: String
    ) {
        transactionsViewModel = TransactionsViewModel(
            retriever: transactionsStore.retrivePublisher,
            saver: transactionsStore.savePublisher,
            deleter: transactionsStore.deletePublisher
        )
        transactionsViewModel.retrieve()
        
        let currentPricesLoaderFactory = CurrentPricesLoaderFactory(
            httpClient: httpClient, baseURL: baseURL, token: token, store: currentPricesStore
        )
        let currentPriceLoader = currentPricesLoaderFactory.makeRemoteCurrentPriceLoaderWithLocalFeedback
        currentPricesViewModel = CurrentPricesViewModel(loader: currentPriceLoader)
        currentPricesLoaderFactory.onRemoteLoaderError = { [weak self] in
            self?.currentPricesViewModel.error = "Connection error. Trying to load prices from cache"
        }
        
        transactionsFlow.setupSubscriptions(
            transactionsViewModel: transactionsViewModel,
            alertViewModel: alertViewModel
        )
        transactionsFlow.setupSubscriptions(
            transactionsViewModel: transactionsViewModel,
            httpClient: httpClient,
            url: TransactionsEndPoint.put.url(projectID: transactionsProjectID)
        )
        
        portfolioFlow.setupSubscriptions(
            portfolioViewModel: portfolioViewModel,
            transactionsViewModel: transactionsViewModel,
            currentPricesViewModel: currentPricesViewModel
        )
        currentPricesFlow.setupSubscriptions(
            currentPricesViewModel: currentPricesViewModel,
            transactionsViewModel: transactionsViewModel,
            alertViewModel: alertViewModel
        )
    }
}
