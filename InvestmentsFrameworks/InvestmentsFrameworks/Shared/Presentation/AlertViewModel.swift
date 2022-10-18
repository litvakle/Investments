//
//  AlertViewModel.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 18.10.2022.
//

import Foundation

public class AlertViewModel: ObservableObject {
    @Published public var isActive = false
    @Published public var title = ""
    @Published public var message = ""
    
    public init() {}
    
    public func showAlert(title: String, message: String = "") {
        self.title = title
        self.message = message
        isActive = true
    }
}
