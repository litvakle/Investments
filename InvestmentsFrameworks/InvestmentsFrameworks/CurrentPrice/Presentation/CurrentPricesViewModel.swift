//
//  CurrentPricesViewModel.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 29.09.2022.
//

import Foundation
import Combine

public typealias CurrentPriceLoader = (String) -> AnyPublisher<CurrentPrice, Error>

public class CurrentPricesViewModel: ObservableObject {
    @Published public var currentPrices = CurrentPrices()
    @Published public var loadingTickets = Set<String>()
    @Published public var error: String?

    public var isLoading: Bool {
        !loadingTickets.isEmpty
    }
    
    public let loader: CurrentPriceLoader
    var cancellables = Set<AnyCancellable>()
    
    public init(loader: @escaping CurrentPriceLoader) {
        self.loader = loader
    }
    
    public func loadPrices(for tickets: [String]) {
        guard !isLoading else { return }
        error = nil
        
        tickets.forEach { [weak self] ticket in
            self?.loadingTickets.insert(ticket)
            loader(ticket)
                .dispatchOnMainQueue()
                .sink { completion in
                    if case .failure = completion {
                        self?.error = "Error loading prices"
                    }
                    self?.loadingTickets.remove(ticket)
                } receiveValue: { price in
                    self?.currentPrices[ticket] = price
                }
                .store(in: &cancellables)
        }
    }
    
    public func refreshPrices() {
        loadPrices(for: Array(currentPrices.keys))
    }
}
