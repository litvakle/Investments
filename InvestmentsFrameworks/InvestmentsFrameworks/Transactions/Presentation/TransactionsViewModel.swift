//
//  TransactionsViewModel.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 15.09.2022.
//

import Foundation
import Combine

public class TransactionsViewModel: ObservableObject {
    public typealias RetrievePublisher = (() -> AnyPublisher<[Transaction], Error>)
    public typealias SavePublisher = ((Transaction) -> AnyPublisher<Void, Error>)
    public typealias DeletePublisher = ((Transaction) -> AnyPublisher<Void, Error>)
    
    private let retriever: RetrievePublisher?
    private let saver: SavePublisher?
    private let deleter: DeletePublisher?
    
    @Published public private(set) var isRetrieving = false
    @Published public var error: Error?
    @Published public private(set) var transactions = [Transaction]()
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(retriever: RetrievePublisher?, saver: SavePublisher?, deleter: DeletePublisher?) {
        self.retriever = retriever
        self.saver = saver
        self.deleter = deleter
    }
    
    public func retrieve() {
        guard let retriever = retriever else { return }

        isRetrieving = true
        retriever()
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.error = error
                }
                self?.isRetrieving = false
            }, receiveValue: { [weak self] retrievedTransactions in
                self?.transactions = retrievedTransactions.sorted(by: { $0.date > $1.date })
            })
            .store(in: &cancellables)
    }
    
    public func save(_ transaction: Transaction) {
        guard let saver = saver else { return }
        
        saver(transaction)
            .sink { completion in
                if case let .failure(error) = completion {
                    self.error = error
                }
            } receiveValue: { [weak self] _ in
                if let index = self?.transactions.firstIndex(where: { $0.id == transaction.id }) {
                    self?.transactions[index] = transaction
                } else {
                    self?.transactions.append(transaction)
                    self?.transactions.sort(by: { $0.date > $1.date })
                }
            }
            .store(in: &cancellables)
    }
    
    public func delete(_ transaction: Transaction) {
        guard let deleter = deleter else { return }

        deleter(transaction)
            .sink { completion in
                if case let .failure(error) = completion {
                    self.error = error
                }
            } receiveValue: { [weak self] _ in
                if let index = self?.transactions.firstIndex(where: { $0.id == transaction.id }) {
                    self?.transactions.remove(at: index)
                }
            }
            .store(in: &cancellables)
    }
}
