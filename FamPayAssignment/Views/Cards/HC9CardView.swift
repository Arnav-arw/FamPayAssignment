//
//  HC9CardView.swift
//  FamPayAssignment
//
//  Created by Arnav Singhal on 20/03/24.
//

import SwiftUI

struct HC9CardView: View {
    
    var card: CardGroupModel
    
    var body: some View {
        VStack {
            if card.is_scrollable {
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(card.cards!) { minicard in
                                gradientCardView(minicard)
                            }
                        }
                    }
                }
            } else {
                HStack {
                    gradientCardView(card.cards?.first)
                }
            }
        }
        .frame(height: card.height ?? 50)
        .padding(.leading, card.is_scrollable ? 25 : 0)
    }
    
    @ViewBuilder
    func gradientCardView(_ minicard: CardModel?) -> some View {
        if let minicard {
            LinearGradient(gradient: Gradient(colors: Helpers.fromHexCodes(minicard.bg_gradient?.colors ?? [])),
                           startPoint: .bottomTrailing,
                           endPoint: .topLeading)
            .frame(width: card.is_scrollable ? card.height ?? 50 : UIScreen.main.bounds.width - 40)
            .clipShape(.rect(cornerRadius: 18))
        }
    }
}
