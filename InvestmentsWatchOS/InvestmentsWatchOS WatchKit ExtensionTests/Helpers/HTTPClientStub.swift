//
//  HTTPClientStub.swift
//  InvestmentsWatchOS WatchKit ExtensionTests
//
//  Created by Lev Litvak on 18.10.2022.
//

import Foundation
import InvestmentsFrameworks

class HTTPClientStub: HTTPClient {
    private class Task: HTTPClientTask {
        func cancel() {}
    }
    
    var putRequestsCallCount = 0
    
    private let stub: (URL) -> HTTPClient.Result
    
    init(stub: @escaping (URL) -> HTTPClient.Result) {
        self.stub = stub
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        completion(stub(url))
        return Task()
    }
    
    func put(_ data: Data, to url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        putRequestsCallCount += 1
        completion(stub(url))
        return Task()
    }
}

extension HTTPClientStub {
    static var offline: HTTPClientStub {
        HTTPClientStub(stub: { _ in .failure(NSError(domain: "offline", code: 0)) })
    }
    
    static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
        HTTPClientStub { url in .success(stub(url)) }
    }
}
