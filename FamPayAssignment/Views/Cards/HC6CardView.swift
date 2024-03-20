//
//  HC6CardView.swift
//  FamPayAssignment
//
//  Created by Arnav Singhal on 19/03/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct HC6CardView: View {
    
    var card: CardGroupModel
    
    var body: some View {
        VStack {
            if card.is_scrollable {
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(card.cards!) { minicard in
                                cardWithArrow(minicard)
                            }
                        }
                    }
                }
            } else {
                HStack {
                    cardWithArrow(card.cards?.first)
                }
            }
        }
        .frame(height: card.height ?? 50)
        .padding(.top)
        .padding(.leading, card.is_scrollable ? 25 : 0)
    }
    
    @ViewBuilder
    private func cardWithArrow(_ minicard: CardModel?) -> some View {
        if let minicard {
            HStack {
                if let imgURLString = minicard.icon?.image_url, 
                    let imageURL = URL(string: imgURLString) {
                    WebImage(url: imageURL)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width: card.icon_size ?? 30)
                }
                Text(minicard.formatted_title?.entities.first?.text ?? "")
                    .foregroundStyle(Color(hex: minicard.formatted_title?.entities.first?.color)!)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                Spacer()
                Image("arrow")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 15)
            }
            .frame(width: card.is_scrollable ? deviceWidth - 80 : deviceWidth - 70)
            .padding(.all)
            .background(Color.white)
            .cornerRadius(12)
        }
    }
}
