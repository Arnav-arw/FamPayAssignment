//
//  FeedViewModel.swift
//  FamPayAssignment
//
//  Created by Arnav Singhal on 19/03/24.
//

import Foundation

class FeedViewModel: ObservableObject {
    
    @Published var feed: FeedResponeModel?
    
    let dataManager = FeedManager()
    
    static let shared = FeedViewModel()
    
    init() {
        fetchFeed()
    }
    
    func fetchFeed() {
        DispatchQueue.main.async {
            Task {
                self.feed = await self.dataManager.fetchFeed()
            }
        }
    }
    
}
