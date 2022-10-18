//
//  CurrentPricesFlowTests.swift
//  InvestmentsWatchOS WatchKit ExtensionTests
//
//  Created by Lev Litvak on 18.10.2022.
//

import XCTest
import InvestmentsFrameworksWatchOS

class CurrentPricesFlow {
    
}

//class CurrentPricesFlowTests: XCTestCase {
//    func test_transactionsUpdate_leadsToUpdateCurrentPricesForAllTickets() {
//        let (sut, transactionsViewModel, currentPricesViewModel, currentPriceLoader, alertViewModel) = makeSUT()
//        sut.setupSubscriptions(currentPricesViewModel: currentPricesViewModel, transactionsViewModel: transactionsViewModel, alertViewModel: alertViewModel)
//        currentPricesViewModel.currentPrices = [
//            "AAA": CurrentPrice(price: 100),
//            "BBB": CurrentPrice(price: 200)
//        ]
//        
//        makePortfolioTransactions().forEach { transactionsViewModel.save($0) }
//        XCTAssertEqual(currentPriceLoader.loadFeedCallCount, 1, "Expected only one load for 'CCC' ticket")
//    }
//    
//    // MARK: - Helpers
//    
//    private func makeSUT(
//        store: InMemoryStore = .empty,
//        file: StaticString = #filePath,
//        line: UInt = #line
//    ) -> (CurrentPricesFlow, TransactionsViewModel, CurrentPricesViewModel, CurrentPriceLoaderSpy, AlertViewModel) {
//        let transactionsViewModel = TransactionsViewModel(retriever: store.retrivePublisher, saver: store.savePublisher, deleter: store.deletePublisher)
//        transactionsViewModel.retrieve()
//        let currentPriceLoader = CurrentPriceLoaderSpy()
//        let currentPricesViewModel = CurrentPricesViewModel(loader: currentPriceLoader.loadPublisher)
//        let alertViewModel = AlertViewModel()
//        let sut = CurrentPricesFlow()
//        
//        trackForMemoryLeaks(store, file: file, line: line)
//        trackForMemoryLeaks(transactionsViewModel, file: file, line: line)
//        trackForMemoryLeaks(currentPriceLoader, file: file, line: line)
//        trackForMemoryLeaks(currentPricesViewModel, file: file, line: line)
//        trackForMemoryLeaks(alertViewModel, file: file, line: line)
//        trackForMemoryLeaks(sut, file: file, line: line)
//        
//        return (sut, transactionsViewModel, currentPricesViewModel, currentPriceLoader, alertViewModel)
//    }
//}
//
//public class CurrentPriceLoaderSpy {
//    public var requests = [(ticket: String, publisher: PassthroughSubject<CurrentPrice, Error>)]()
//    
//    public var loadFeedCallCount: Int {
//        return requests.count
//    }
//    
//    public func loadPublisher(for ticket: String) -> AnyPublisher<CurrentPrice, Error> {
//        let publisher = PassthroughSubject<CurrentPrice, Error>()
//        requests.append((ticket, publisher))
//        return publisher.eraseToAnyPublisher()
//    }
//    
//    public func completeCurrentPriceLoadingWithError(at index: Int = 0) {
//        requests[index].publisher.send(completion: .failure(anyNSError()))
//    }
//    
//    public func completeCurrentPriceLoading(with currentPrice: CurrentPrice, at index: Int = 0) {
//        requests[index].publisher.send(currentPrice)
//        requests[index].publisher.send(completion: .finished)
//    }
//}
//
//class InMemoryStore: TransactionsStore {
//    var transactions: [Transaction]
//    
//    var currentPrices: CurrentPrices
//    
//    init(transactions: [Transaction], currentPrices: CurrentPrices) {
//        self.transactions = transactions
//        self.currentPrices = currentPrices
//    }
//    
//    init(transactions: [Transaction]) {
//        self.transactions = transactions
//        self.currentPrices = [:]
//    }
//    
//    init(currentPrices: CurrentPrices) {
//        self.transactions = []
//        self.currentPrices = currentPrices
//    }
//    
//    func retrieve() throws -> [Transaction] {
//        return transactions
//    }
//    
//    func save(_ transaction: Transaction) throws {
//        if let index = transactions.firstIndex(of: transaction) {
//            transactions[index] = transaction
//        } else {
//            transactions.append(transaction)
//        }
//    }
//    
//    func delete(_ transaction: Transaction) throws {
//        if let index = transactions.firstIndex(of: transaction) {
//            transactions.remove(at: index)
//        }
//    }
//}
//
//extension InMemoryStore: CurrentPricesStore {
//    func retrieve(for ticket: String) throws -> CurrentPrice? {
//        currentPrices[ticket]
//    }
//    
//    func save(_ currentPrice: CurrentPrice, for ticket: String) throws {
//        currentPrices[ticket] = currentPrice
//    }
//}
//
//extension InMemoryStore {
//    static var empty: InMemoryStore {
//        InMemoryStore(transactions: [], currentPrices: [:])
//    }
//    
//    static var withStoredData: InMemoryStore {
//        InMemoryStore(transactions: makePortfolioTransactions(), currentPrices: makeCurrentPrices())
//    }
//}
