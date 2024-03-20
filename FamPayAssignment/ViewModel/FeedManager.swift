//
//  FeedManager.swift
//  FamPayAssignment
//
//  Created by Arnav Singhal on 19/03/24.
//

import Foundation

class FeedManager {
    
    func fetchFeed() async -> FeedResponeModel? {
        let url = URL(string: "https://polyjuice.kong.fampay.co/mock/famapp/feed/home_section/?slugs=famx-paypage")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let responseData = try decoder.decode([FeedResponeModel].self, from: data)
            
            return responseData.first!
        } catch {
            print(error)
            return nil
        }
    }
    
    func fetchLocalFeed() -> FeedResponeModel? {
        if let fileURL = Bundle.main.url(forResource: "HomeFeed", withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let homedata = try decoder.decode([FeedResponeModel].self, from: data)
                return homedata.first!
            } catch {
                print("error in local feed")
            }
        }
        return nil
    }
    
}
