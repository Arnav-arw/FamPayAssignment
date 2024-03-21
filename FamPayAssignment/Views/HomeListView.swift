//
//  HomeListView.swift
//  FamPayAssignment
//
//  Created by Arnav Singhal on 19/03/24.
//

import SwiftUI

struct HomeListView: View {
    
    @State var cards: [CardGroupModel]
    
    @State private var isRefreshing = false
    @StateObject private var feedVM = FeedViewModel.shared
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(cards, id: \.cardUniqueID) { card in
                switch (card.design_type) {
                    case .bigDisplayCard:
                        HC3CardView(card: card)
                    case .smallCardWithArrow:
                        HC6CardView(card: card)
                    case .imageCard:
                        HC5CardView(card: card)
                    case .dynamicWidthCard:
                        HC9CardView(card: card)
                    case .smallDisplayCard:
                        HC1CardView(card: card)
                    default:
                        EmptyView()
                }
            }
        }
        .background {
            Color("BG-Color")
                .frame(width: deviceWidth)
                .ignoresSafeArea(.all)
        }
        .gesture(
            // Gesture for reloading feed
            DragGesture()
                .onChanged { value in
                    if value.translation.height > 50 && !isRefreshing {
                        isRefreshing = true
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        feedVM.refreshFeed()
                    }
                }
                .onEnded { _ in
                    isRefreshing = false
                }
        )
    }
}
