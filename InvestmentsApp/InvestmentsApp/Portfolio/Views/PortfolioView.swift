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
    let isLoading: Bool
    let onRefresh: () -> Void
    
    var body: some View {
        List {
            Section {
                summary
            }
            ForEach(viewModel.items) { item in
                PortfolioRow(for: item)
            }
            .accessibilityIdentifier("PORTFOLIO_ITEMS")
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Portfolio")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isLoading {
                    loadingIndicator
                } else {
                    refresh
                }
            }
        }
    }
    
    var loadingIndicator: some View {
        ProgressView()
            .accessibilityIdentifier("LOADING_INDICATOR")
    }
    
    var summary: some View {
        VStack {
            summaryCost
            summaryProfit
            summaryProfitPercent
        }
        .font(.title.bold())
    }
    
    var summaryCost: some View {
        let formatter = NumberFormatter.currencyFormatter(minFractionDigits: 2, maxFractionDigits: 2, currencyCode: "USD", locale: .current)
        
        return HStack {
            Text("Cost: ")
            Spacer()
            Text(NSNumber(value: viewModel.summary.cost), formatter: formatter)
                .accessibilityIdentifier("SUMMARY_COST")
        }
    }
    
    var summaryProfit: some View {
        let formatter = NumberFormatter.currencyFormatter(minFractionDigits: 2, maxFractionDigits: 2, currencyCode: "USD", locale: .current)
        
        return HStack {
            Text("Profit: ")
            Spacer()
            Text(NSNumber(value: viewModel.summary.profit), formatter: formatter)
                .foregroundColor(viewModel.summary.profit >= 0 ? .green : .red)
                .accessibilityIdentifier("SUMMARY_PROFIT")
        }
    }
    
    var summaryProfitPercent: some View {
        let formatter = NumberFormatter.percentFormatter(minFractionDigits: 2, maxFractionDigits: 2, locale: .current)
        let sign = viewModel.summary.profitPercent >= 0 ? "+" : ""
        
        return HStack {
            Spacer()
            (Text(sign) + Text(NSNumber(value: viewModel.summary.profitPercent), formatter: formatter))
                .foregroundColor(viewModel.summary.profitPercent >= 0 ? .green : .red)
                .accessibilityIdentifier("SUMMARY_PROFIT_PERCENT")
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

struct PortfolioView_Previews: PreviewProvider {
    static var viewModel: PortfolioViewModel {
        let viewModel = PortfolioViewModel()
        viewModel.calcPortfolio(for: [
            InvestmentTransaction(ticket: "BBB", type: .buy, quantity: 1, price: 10, sum: 10),
            InvestmentTransaction(ticket: "AAA", type: .buy, quantity: 1, price: 10, sum: 10),
            InvestmentTransaction(ticket: "AAA", type: .buy, quantity: 2, price: 20, sum: 40),
            InvestmentTransaction(ticket: "AAA", type: .buy, quantity: 3, price: 10, sum: 30),
            InvestmentTransaction(ticket: "BBB", type: .buy, quantity: 2, price: 20, sum: 40)
        ], with: [
            "AAA": CurrentPrice(price: 25),
            "BBB": CurrentPrice(price: 5)
        ])
        
        return viewModel
    }
    
    static var previews: some View {
        Group {
            NavigationView {
                PortfolioView(viewModel: viewModel, isLoading: false, onRefresh: {})
            }
            
            NavigationView {
                PortfolioView(viewModel: viewModel, isLoading: true, onRefresh: {})
            }
            
            NavigationView {
                PortfolioView(viewModel: viewModel, isLoading: false, onRefresh: {})
            }
            .preferredColorScheme(.dark)
            
            NavigationView {
                PortfolioView(viewModel: viewModel, isLoading: true, onRefresh: {})
            }
            .preferredColorScheme(.dark)
        }
    }
}
