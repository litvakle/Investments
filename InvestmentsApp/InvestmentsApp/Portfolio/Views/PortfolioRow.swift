//
//  PortfolioRow.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 08.10.2022.
//

import SwiftUI
import InvestmentsFrameworks

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
            
            HStack {
                quantity
                Spacer()
                price
            }
            
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
        
        return (
            Text("Profit: ") +
            Text(NSNumber(value: item.profit), formatter: formatter)
                .foregroundColor(item.profit >= 0 ? .green : .red)
        )
        .multilineTextAlignment(.trailing)
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

struct PortfolioRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PortfolioRow(for: PortfolioView_Previews.viewModel.items[0])
                .previewLayout(.sizeThatFits)

            PortfolioRow(for: PortfolioView_Previews.viewModel.items[0])
                .environment(\.dynamicTypeSize, .xxxLarge)
                .previewLayout(.sizeThatFits)
            
            PortfolioRow(for: PortfolioView_Previews.viewModel.items[0])
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)

            PortfolioRow(for: PortfolioView_Previews.viewModel.items[0])
                .environment(\.dynamicTypeSize, .xxxLarge)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
