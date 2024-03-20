//
//  HomeListView.swift
//  FamPayAssignment
//
//  Created by Arnav Singhal on 19/03/24.
//

import SwiftUI

struct HomeListView: View {
    
    @State var feed: [CardGroupModel]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(feed) { card in
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
                    default: EmptyView()
                }
            }
        }
        .background {
            Color("BG-Color")
                .frame(width: deviceWidth)
                .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    HomeListView(feed: [])
}

