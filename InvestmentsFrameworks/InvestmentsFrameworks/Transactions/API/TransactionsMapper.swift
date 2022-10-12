//
//  TransactionsMapper.swift
//  InvestmentsFrameworks
//
//  Created by Lev Litvak on 12.10.2022.
//

import Foundation

public class TransactionsMapper {
    struct TransactionAPI: Decodable {
        let id: String
        let date: Date
        let ticket: String
        let type: String
        let quantity: Double
        let price: Double
        let sum: Double
        
        var transaction: Transaction {
            Transaction(
                id: UUID(uuidString: id) ?? UUID(),
                date: date,
                ticket: ticket,
                type: TransactionType.fromString(type),
                quantity: quantity,
                price: price,
                sum: sum
            )
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
        case connectionError
    }
    
    public static var isOK: Int { 200 }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Transaction] {
        guard response.statusCode == isOK else { throw Error.connectionError }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let decoded = try? decoder.decode([TransactionAPI].self, from: data) else { throw Error.invalidData }
        
        return decoded.map { $0.transaction }
    }
}
