//
//  FeedViewModel.swift
//  FamPayAssignment
//
//  Created by Arnav Singhal on 19/03/24.
//

import Foundation
import SwiftUI

class FeedViewModel: ObservableObject {
    
    @Published var cards: [CardGroupModel]?
    
    @Published var remindLaterCardIDs: Set<Int> = []
    @AppStorage("dismissedPosts") var dismissedCardIDs: [Int] = []
    
    let dataManager = FeedManager()
    
    static let shared = FeedViewModel()
    
    init() {
        fetchFeed()
    }
    
    func fetchFeed() {
        DispatchQueue.main.async {
            Task {
                guard let feed = await self.dataManager.fetchFeed() else { return }
                let filteredDismissedCards = self.filterFeedForDismissCards(feed.cards)
                let filteredLaterCards = self.filterFeedForRemindLaterCards(filteredDismissedCards)
                self.cards = filteredLaterCards
            }
        }
    }
    
    func refreshFeed() {
        self.cards = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.fetchFeed()
        }
    }
    
    func dismissCard(for cardID: Int) {
        self.dismissedCardIDs.append(cardID)
        let temp = cards?.filter { $0.id != cardID }
        cards = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.cards = temp
        }
    }
    
    func remindLaterCard(for cardID: Int) {
        self.remindLaterCardIDs.insert(cardID)
        let temp = cards?.filter { $0.id != cardID }
        cards = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.cards = temp
        }
    }
    
    private func filterFeedForDismissCards(_ feed: [CardGroupModel]) -> [CardGroupModel] {
        let filteredFeed = feed.filter { !dismissedCardIDs.contains($0.id) }
        return filteredFeed
    }
    
    private func filterFeedForRemindLaterCards(_ feed: [CardGroupModel]) -> [CardGroupModel] {
        let filteredFeed = feed.filter { !remindLaterCardIDs.contains($0.id) }
        return filteredFeed
    }
    
}
