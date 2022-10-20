//
//  TransactionsLoaderFactory.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 20.10.2022.
//

import Combine
import InvestmentsFrameworks

class TransactionsPublishersFactory {
    let scheduler: AnyDispatchQueueScheduler
    let retriever: TransactionsRetriever
    let saver: TransactionsSaver
    let deleter: TransactionsDeleter
    
    init(scheduler: AnyDispatchQueueScheduler, retriever: TransactionsRetriever, saver: TransactionsSaver, deleter: TransactionsDeleter) {
        self.scheduler = scheduler
        self.retriever = retriever
        self.saver = saver
        self.deleter = deleter
    }
    
    func makeLocalTransactionsRetriever() -> AnyPublisher<[Transaction], Error> {
        retriever
            .retrivePublisher()
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    func makeLocalTransactionsSaver(for transaction: Transaction) -> AnyPublisher<Void, Error> {
        saver
            .savePublisher(for: transaction)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    func makeLocalTransactionsDeleter(for transaction: Transaction) -> AnyPublisher<Void, Error> {
        deleter
            .deletePublisher(for: transaction)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
}
