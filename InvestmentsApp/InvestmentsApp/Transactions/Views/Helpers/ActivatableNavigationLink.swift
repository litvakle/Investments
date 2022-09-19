//
//  NavigationDestinationView.swift
//  InvestmentsApp
//
//  Created by Lev Litvak on 18.09.2022.
//

import SwiftUI

class NavigationState: ObservableObject {
    @Published var isActive: Bool = false
    
    func activate() {
        isActive = true
    }
    
    func deactivate() {
        isActive = false
    }
}

struct ActivatableNavigationLink<Content>: View where Content: View {
    @ObservedObject var state: NavigationState
    let destination: () -> Content
    
    var body: some View {
        NavigationLink(
            isActive: $state.isActive,
            destination: destination,
            label: { EmptyView() }
        )
    }
}
