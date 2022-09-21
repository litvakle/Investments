//
//  TransactionView.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 15.09.2022.
//

import SwiftUI
import InvestmentsFrameworks

struct TransactionView: View {
    @ObservedObject private var vm: TransactionViewModel
    
    init(_ viewModel: TransactionViewModel) {
        self.vm = viewModel
    }
    
    var body: some View {
        List {
            Group {
                type
                date
                ticket
                quantity
                sum
                price
            }
            .listRowSeparator(.hidden)
        }
        .navigationTitle("Transaction")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save", action: { vm.save() })
            }
        }
    }
    
    private var type: some View {
        Picker("Title", selection: $vm.type) {
            Text("Buy")
                .tag(TransactionType.buy)
            
            Text("Sell")
                .tag(TransactionType.sell)
        }
        .pickerStyle(.segmented)
        .accessibilityIdentifier("TYPE")
    }
    
    private var date: some View {
        DatePicker("Date", selection: $vm.date, in: ...Date(), displayedComponents: .date)
            .accessibilityIdentifier("DATE")
    }
    
    private var ticket: some View {
        VStack {
            HStack {
                Text("Ticket")
                
                TextField("XXX", text: $vm.ticket)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.alphabet)
                    .textInputAutocapitalization(.characters)
                    .disableAutocorrection(true)
                    .accessibilityIdentifier("TICKET")
            }
                
            if let ticketErrorMessage = vm.ticketErrorMessage {
                Text(ticketErrorMessage)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var quantity: some View {
        let formatter = NumberFormatter.decimalFormatter(
            minFractionDigits: 0,
            maxFractionDigits: 4,
            locale: .current
        )
        
        return VStack {
            HStack {
                Text("Quantity")
                
                TextField("", value: $vm.quantity, formatter: formatter)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .accessibilityIdentifier("QUANTITY")
            }
            
            if let quantityErrorMessage = vm.quantityErrorMessage {
                Text(quantityErrorMessage)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var sum: some View {
        let formatter = NumberFormatter.currencyFormatter(
            minFractionDigits: 2,
            maxFractionDigits: 2,
            currencyCode: "USD"
        )
        
        return VStack {
            HStack {
                Text("Sum")
                
                TextField("", value: $vm.sum, formatter: formatter)
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .accessibilityIdentifier("SUM")
            }
            
            if let sumErrorMessage = vm.sumErrorMessage {
                Text(sumErrorMessage)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var price: some View {
        let formatter = NumberFormatter.currencyFormatter(
            minFractionDigits: 2,
            maxFractionDigits: 8,
            currencyCode: "USD"
        )
        
        return VStack {
            HStack {
                Text("Price")

                Spacer()
                
                Text(NSNumber(value: vm.price), formatter: formatter)
                    .accessibilityIdentifier("PRICE")
            }
        }
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                TransactionView(TransactionViewModel(transaction: InvestmentTransaction.previewData[0], onSave: { _ in }))
            }
            
            NavigationView {
                TransactionView(TransactionViewModel(transaction: InvestmentTransaction(), onSave: { _ in }))
            }
        }
    }
}
