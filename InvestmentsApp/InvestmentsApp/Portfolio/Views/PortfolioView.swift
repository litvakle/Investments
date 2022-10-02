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
    let onRefresh: () -> Void
    
    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                PortfolioRow(for: item)
            }
            .accessibilityIdentifier("PORTFOLIO_ITEMS")
        }
        .navigationTitle("Portfolio")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                refresh
            }
        }
    }
    
    var refresh: some View {
        Button {
            onRefresh()
        } label: {
            Image(systemName: "arrow.clockwise")
        }
        .accessibilityIdentifier("REFRESH")
    }
}

struct PortfolioRow: View {
    var item: PortfolioItem
    
    init(for item: PortfolioItem) {
        self.item = item
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ticket
                Spacer()
                cost
            }
            .padding(.bottom, 3)
            
            HStack {
                quantity
                Spacer()
                price
            }
            .padding(.bottom, 3)
            
            HStack {
                profit
                Spacer()
                profitPercent
            }
        }
    }
    
    var ticket: some View {
        Text(item.ticket)
            .font(.headline)
            .accessibilityIdentifier("TICKET")
    }
    
    var quantity: some View {
        let formatter = NumberFormatter.decimalFormatter(minFractionDigits: 2, maxFractionDigits: 4, locale: .current)
        
        return (Text("Quantity: ") + Text(NSNumber(value: item.quantity), formatter: formatter))
            .accessibilityIdentifier("QUANTITY")
    }
    
    var price: some View {
        let formatter = NumberFormatter.currencyFormatter(minFractionDigits: 2, maxFractionDigits: 2, currencyCode: "USD", locale: .current)
        
        return (Text("Price: ") + Text(NSNumber(value: item.price), formatter: formatter))
            .multilineTextAlignment(.trailing)
            .accessibilityIdentifier("PRICE")
    }
    
    var cost: some View {
        let formatter = NumberFormatter.currencyFormatter(minFractionDigits: 2, maxFractionDigits: 2, currencyCode: "USD", locale: .current)
        
        return (Text("Cost: ") + Text(NSNumber(value: item.cost), formatter: formatter))
            .accessibilityIdentifier("COST")
    }
    
    var profit: some View {
        let formatter = NumberFormatter.currencyFormatter(minFractionDigits: 2, maxFractionDigits: 2, currencyCode: "USD", locale: .current)
        
        return (Text("Profit: ") + Text(NSNumber(value: item.profit), formatter: formatter))
            .multilineTextAlignment(.trailing)
            .foregroundColor(item.profit >= 0 ? .green : .red)
            .accessibilityIdentifier("PROFIT")
    }
    
    var profitPercent: some View {
        let formatter = NumberFormatter.percentFormatter(minFractionDigits: 2, maxFractionDigits: 2, locale: .current)
        let sign = item.profitPercent >= 0 ? "+" : ""
        
        return (Text(sign) + Text(NSNumber(value: item.profitPercent), formatter: formatter))
            .multilineTextAlignment(.trailing)
            .foregroundColor(item.profit >= 0 ? .green : .red)
            .accessibilityIdentifier("PROFIT_PERCENT")
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
        ], with: [
            "AAA": CurrentPrice(price: 25),
            "BBB": CurrentPrice(price: 5)
        ])
        
        return viewModel
    }
    
    static var previews: some View {
        PortfolioView(viewModel: viewModel, onRefresh: {})
    }
}
