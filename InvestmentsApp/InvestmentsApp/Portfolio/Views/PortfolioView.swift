//
//  PortfolioView.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 26.09.2022.
//

import SwiftUI
import InvestmentsFrameworks

struct PortfolioView: View {
    @ObservedObject var viewModel: PortfolioViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                PortfolioRow(for: item)
            }
            .accessibilityIdentifier("PORTFOLIO_ITEMS")
        }
    }
}

struct PortfolioRow: View {
    var item: PortfolioItem
    
    init(for item: PortfolioItem) {
        self.item = item
    }
    
    var body: some View {
        HStack {
            VStack {
                ticket
                quantity
            }
            Spacer()
            sum
        }
    }
    
    var ticket: some View {
        Text(item.ticket)
            .font(.headline)
            .accessibilityIdentifier("TICKET")
    }
    
    var quantity: some View {
        let formatter = NumberFormatter.decimalFormatter(minFractionDigits: 2, maxFractionDigits: 4, locale: .current)
        
        return Text(NSNumber(value: item.quantity), formatter: formatter)
            .font(.subheadline)
            .accessibilityIdentifier("QUANTITY")
    }
    
    var sum: some View {
        let formatter = NumberFormatter.currencyFormatter(minFractionDigits: 2, maxFractionDigits: 2, currencyCode: "USD", locale: .current)
        
        return Text(NSNumber(value: item.sum), formatter: formatter)
            .multilineTextAlignment(.trailing)
            .accessibilityIdentifier("SUM")
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var viewModel: PortfolioViewModel {
        let viewModel = PortfolioViewModel()
        viewModel.createItems(for: [
            InvestmentTransaction(ticket: "BBB", type: .buy, quantity: 1, price: 10, sum: 10),
            InvestmentTransaction(ticket: "AAA", type: .buy, quantity: 1, price: 10, sum: 10),
            InvestmentTransaction(ticket: "AAA", type: .buy, quantity: 2, price: 20, sum: 20),
            InvestmentTransaction(ticket: "AAA", type: .buy, quantity: 3, price: 10, sum: 30),
            InvestmentTransaction(ticket: "BBB", type: .buy, quantity: 2, price: 20, sum: 20)
        ])
        
        return viewModel
    }
    static var previews: some View {
        PortfolioView(viewModel: viewModel)
    }
}
