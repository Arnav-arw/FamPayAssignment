//
//  HC5CardView.swift
//  FamPayAssignment
//
//  Created by Arnav Singhal on 19/03/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct HC5CardView: View {
    
    var card: CardGroupModel
    
    var body: some View {
        VStack {
            if card.is_scrollable {
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(card.cards!) { minicard in
                                imageView(minicard)
                            }
                        }
                    }
                }
            } else {
                HStack {
                    imageView(card.cards?.first)
                }
            }
        }
        .padding(.top)
    }
    
    @ViewBuilder
    func imageView(_ minicard: CardModel?) -> some View {
        if let minicard {
            if let imgURLString = minicard.bg_image?.image_url,
                let imageURL = URL(string: imgURLString),
               let aspectRatio = minicard.bg_image?.aspect_ratio {
                WebImage(url: imageURL)
                    .resizable()
                    .aspectRatio(aspectRatio, contentMode: .fill)
                    .frame(width: deviceWidth - 40)
            }
        }
    }
}
