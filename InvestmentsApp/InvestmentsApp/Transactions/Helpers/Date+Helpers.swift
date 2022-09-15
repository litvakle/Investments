//
//  Date+Helpers.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 15.09.2022.
//

import Foundation

extension Date {
    func asTransactionsListItem() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: self)
    }
}
