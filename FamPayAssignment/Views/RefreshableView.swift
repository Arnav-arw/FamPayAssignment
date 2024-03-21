//
//  RefreshableView.swift
//  FamPayAssignment
//
//  Created by Arnav Singhal on 21/03/24.
//

import SwiftUI

fileprivate let refreshableScrollViewFrameLayer = "RefreshableScrollViewFrameLayer"

struct RefreshableScrollView<Content: View>: View {
    
    var axes: Axis.Set
    var showsIndicators: Bool
    var content: () -> Content
    @Binding private var isRefreshing: Bool
    
    @State private var previousOffset: CGFloat = 0
    @State private var canRefresh = true
    private var offsetForRefreshTrigger: CGFloat = 50
    private var onRefreshAction: () -> Void
    
    init(_ axes: Axis.Set = .vertical,
         showsIndicators: Bool = true,
         isRefreshing: Binding<Bool>,
         @ViewBuilder content: @escaping () -> Content,
         onRefresh: @escaping () -> Void
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.content = content
        self._isRefreshing = isRefreshing
        self.onRefreshAction = onRefresh
    }
    
    var body: some View {
        ZStack {
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .animation(.easeInOut, value: isRefreshing)
                    .offset(y: isRefreshing ? 24 : -200)
                    .zIndex(-1)
                Spacer()
            }.clipped()
            
            ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: showsIndicators) {
                offsetReader
                content()
                    .animation(.easeInOut, value: isRefreshing)
                    .offset(y: isRefreshing ? 72 : 0)
                
            }
            .onPreferenceChange(OffsetPreferenceKey.self, perform: { value in
                if canRefresh
                    && value > previousOffset
                    && value > offsetForRefreshTrigger
                    && !isRefreshing {
                    
                    onRefreshAction()
                    canRefresh = false
                }
                
                previousOffset = value
                
                if(previousOffset < 4) {
                    canRefresh = true
                }
            })
            
            .coordinateSpace(name: refreshableScrollViewFrameLayer)
        }
    }
    
    var offsetReader: some View {
        GeometryReader { proxy in
            Color.red
                .preference(key: OffsetPreferenceKey.self,
                            value: proxy.frame(in: .named(refreshableScrollViewFrameLayer)).minY)
            
        }
        .frame(height: 0)
    }
    
}

fileprivate struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

fileprivate struct RefreshableScrollView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshableScrollView(isRefreshing: .constant(true)) {
            Text("Hello")
            Text("Hello")
        } onRefresh: {
            
        }
    }
}


