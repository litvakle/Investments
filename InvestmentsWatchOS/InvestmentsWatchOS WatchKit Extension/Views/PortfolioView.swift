//
//  PortfolioView.swift
//  InvestmentsWatchOS WatchKit Extension
//
//  Created by Lev Litvak on 15.10.2022.
//

import SwiftUI
import InvestmentsFrameworks

struct PortfolioView: View {
    let cost: Double
    let profit: Double
    let profitPercent: Double
    let isLoading: Bool
    let onRefresh: () -> Void
    
    
    let currencyFormatter = NumberFormatter.currencyFormatter(minFractionDigits: 2, maxFractionDigits: 2, currencyCode: "USD", locale: .current)
    
    let percentFormatter = NumberFormatter.percentFormatter(minFractionDigits: 2, maxFractionDigits: 2, locale: .current)
    
    var body: some View {
        VStack(alignment: .leading) {
            title
            Spacer()
            costView
            profitView
            profitPercentView
            Spacer()
            refresh
        }
    }
    
    var title: some View {
        Text("Portfolio")
            .font(.title2)
    }
    
    var costView: some View {
        HStack {
            Text("Cost:")
            Spacer()
            Text(NSNumber(value: cost), formatter: currencyFormatter)
        }
    }
    
    var profitView: some View {
        HStack {
            Text("Profit:")
            Spacer()
            Text(NSNumber(value: profit), formatter: currencyFormatter)
                .foregroundColor(profit >= 0 ? .green : .red)
        }
    }
    
    var profitPercentView: some View {
        HStack {
            Spacer()
            Text(NSNumber(value: profitPercent), formatter: percentFormatter)
                .foregroundColor(profitPercent >= 0 ? .green : .red)
        }
    }
    
    var refresh: some View {
        Button {
            onRefresh()
        } label: {
            Text(isLoading ? "Fetching data..." : "Refresh")
                .frame(maxWidth: .infinity)
        }
        .disabled(isLoading)
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PortfolioView(cost: 1000, profit: 85, profitPercent: 8.5, isLoading: false, onRefresh: {})
            
            PortfolioView(cost: 1000, profit: 85, profitPercent: 8.5, isLoading: true, onRefresh: {})
            
            PortfolioView(cost: 1000, profit: -85, profitPercent: -8.5, isLoading: true, onRefresh: {})
        }
    }
}
