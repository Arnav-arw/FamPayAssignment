//
//  HC3CardView.swift
//  FamPayAssignment
//
//  Created by Arnav Singhal on 19/03/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct HC3CardView: View {
    
    var card: CardGroupModel
    
    var body: some View {
        VStack {
            if card.is_scrollable, let cards = card.cards {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(0 ..< cards.count, id: \.self) { index in
                            BigDisplayContextualSingleCard(cardGroupId: card.id, card: cards[index])
                                .frame(width: deviceWidth * 0.9, height: deviceWidth * 0.9 * 1.094)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.leading)
                }
            } else if let cardData = card.cards?.first {
                BigDisplayContextualSingleCard(cardGroupId: card.id, card: cardData)
                    .frame(width: deviceWidth, height: deviceWidth * 1.094)
            } else {
                EmptyView()
            }
        }
        .padding(.top)
    }
}

fileprivate struct BigDisplayContextualSingleCard: View {
    
    var cardGroupId: Int
    var card: CardModel
    
    @State private var isExpanded = false
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            GeometryReader { proxy in
                BigDisplayContextualCardActionView(cardGroupId: cardGroupId, card: card)
                    .frame(width: proxy.frame(in: .local).width * 0.4)
                    .background(Color.white)
                    .onTapGesture {
                        isExpanded = false
                    }
                BigDisplayContextualCardContent(card: card)
                    .animation(.spring, value: isExpanded)
                    .offset(x: isExpanded ? proxy.frame(in: .local).width * 0.4 : 0)
                    .onLongPressGesture {
                        isExpanded.toggle()
                    }
            }
        }
        .frame(width: deviceWidth - 40)
        .background(Color.white)
        .cornerRadius(12)
        .clipped()
    }
    
}

private struct BigDisplayContextualCardActionView: View {
    
    let cardGroupId: Int
    let card: CardModel
    
    @StateObject var viewModel = FeedViewModel.shared
    
    var body: some View {
        VStack {
            Spacer()
            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                viewModel.remindLaterCard(for: cardGroupId)
            } label: {
                VStack {
                    Image("bell")
                        .resizable()
                        .frame(width: 22, height: 24)
                    Text("remind later")
                        .font(.system(size: 10))
                        .fixedSize()
                        .foregroundColor(.black)
                }
            }
            .padding()
            .background(Color(hex: "#F7F6F3"))
            .cornerRadius(12)
            
            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                viewModel.dismissCard(for: cardGroupId)
            } label: {
                VStack {
                    Image("clear")
                        .resizable()
                        .frame(width: 22, height: 24)
                    Text("dismiss now")
                        .font(.system(size: 10))
                        .fixedSize()
                        .foregroundColor(.black)
                }
            }
            .padding()
            .background(Color(hex: "#F7F6F3"))
            .cornerRadius(12)
            .padding(.top, 12)
            
            Spacer()
        }
    }
    
}

private struct BigDisplayContextualCardContent: View {
    
    let card: CardModel
    
    var body: some View {
        ZStack {
            if let bgImageURLString = card.bg_image?.image_url,
               let bgImageURL = URL(string: bgImageURLString) {
                WebImage(url: bgImageURL)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(contentMode: .fill)
            }
            VStack(alignment: .leading) {
                if let formatted_titles = card.formatted_title?.updateEntities() {
                    ForEach(formatted_titles) { title in
                        Text(title.text ?? "")
                            .font(.system(size: CGFloat(title.font_size ?? 30)))
                            .foregroundStyle(Color(hex: title.color)!)
                            .padding(.top, title.font_size ?? 30 < 20 ? 30 : 0)
                    }
                }
                VStack {
                    if let cta = card.cta {
                        if cta.count == 1 {
                            if let first = cta.first {
                                Button {
                                    guard let url = URL(string: card.url ?? "") else { return }
                                    UIApplication.shared.open(url)
                                } label: {
                                    Text(first.text)
                                        .foregroundStyle(.white)
                                        .padding(.vertical, 15)
                                        .padding(.horizontal, 50)
                                }
                                .background {
                                    Color.black
                                        .clipShape(.rect(cornerRadius: 18))
                                }
                            }
                        } else {
                            ForEach(cta, id: \.text) { ctaAction in
                                Button {
                                    
                                } label: {
                                    Text(ctaAction.text)
                                        .foregroundStyle(.white)
                                        .padding(.vertical, 15)
                                        .padding(.horizontal, 50)
                                }
                                .background {
                                    Color.black
                                        .clipShape(.rect(cornerRadius: 18))
                                }
                            }
                        }
                    }
                }
                .padding(.top)
            }
            .padding(.horizontal)
            .padding(.trailing, 50)
            .padding(.top, 100)
        }
        .cornerRadius(12)
    }
}
