//
//  HC1CardView.swift
//  FamPayAssignment
//
//  Created by Arnav Singhal on 19/03/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct HC1CardView: View {
    
    var card: CardGroupModel
    
    var body: some View {
        VStack {
            if card.is_scrollable {
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(card.cards!) { minicard in
                                cardView(minicard)
                            }
                        }
                    }
                }
            } else {
                HStack {
                    cardView(card.cards?.first)
                }
            }
        }
        .frame(height: card.height ?? 50)
        .padding(.top)
        .padding(.leading, card.is_scrollable ? 20 : 0)
    }
    
    @ViewBuilder
    func cardView(_ minicard: CardModel?) -> some View {
        if let minicard {
            HStack {
                if let icon = minicard.icon,
                   let imgURLString = icon.image_url,
                   let imgURL = URL(string: imgURLString) {
                    WebImage(url: imgURL)
                        .resizable()
                        .aspectRatio(icon.aspect_ratio ?? 1, contentMode: .fill)
                        .frame(width: 35)
                        .padding(.trailing, 15)
                }
                VStack(alignment: .leading) {
                    if let formatted_title = minicard.formatted_title,
                       let ft_entities_first = formatted_title.entities.first {
                        Text(ft_entities_first.text!)
                            .foregroundStyle(Color(hex: ft_entities_first.color)!)
                    }
                    if let formatted_desc = minicard.formatted_description,
                       let fd_entities_first = formatted_desc.entities.first {
                        Text(fd_entities_first.text!)
                            .foregroundStyle(Color(hex: fd_entities_first.color)!)
                    }
                }
                Spacer()
            }
            .frame(width: card.is_scrollable ? deviceWidth - 80 : deviceWidth - 60)
            .padding(.all)
            .background(Color(hex: minicard.bg_color))
            .cornerRadius(12)
        }
    }
}
