//
//  ContentView.swift
//  FamPayAssignment
//
//  Created by Arnav Singhal on 19/03/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var feedVM = FeedViewModel.shared
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Text("fampay")
                        .font(.system(size: 20, weight: .medium))
                    Image("famPayIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    Spacer()
                }
                VStack {
                    if let feed = feedVM.feed {
                        HomeListView(feed: feed.cards)
                    } else {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
