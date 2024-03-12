//
//  ContentView.swift
//  Stacked Cards - ScrollView
//
//  Created by Ivan Voznyi on 09.03.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                GeometryReader { geometryReader in
                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            ForEach(items) { item in
                                CardView(item)
                                    .padding(.horizontal, 56)
                                    .frame(width: geometryReader.size.width)
                                    .visualEffect { content, geometryProxy in
                                        content
                                            .scaleEffect(scale(geometryProxy, scale: 0.1), anchor: .trailing)
                                            .rotationEffect(rotation(geometryProxy, rotation: 5))
                                            .offset(x: minX(geometryProxy))
                                            .offset(x: excessMinX(geometryProxy, offset: 10))
                                    }
                                    .zIndex(items.zindex(item))
                            }
                        }
                        .padding(.vertical, 25)
                    }
                    .scrollTargetBehavior(.paging)
                    .scrollIndicators(.hidden)
                }
                .frame(height: 410)
            }
            .navigationTitle("Stacked Cards")
        }
    }
    
    @ViewBuilder
    func CardView(_ item: Item) -> some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(item.color.gradient)

    }
    
    func minX(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return minX < 0 ? 0 : -minX
    }
    
    func progress(_ proxy: GeometryProxy, limit: CGFloat = 2) -> CGFloat {
        let maxX = proxy.frame(in: .scrollView(axis: .horizontal)).maxX
        let width = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
        
        /// maxX: 2358.0 / width: 393.0 = 6.0
        /// cappedProgress: 2.0
        /// maxX: 1965.0 / width: 393.0 = 5.0
        /// cappedProgress: 2.0
        /// maxX: 1965.0 / width: 393.0 = 5.0
        /// cappedProgress: 2.0
        /// maxX: 1572.0 / width: 393.0 = 4.0
        /// cappedProgress: 2.0
        /// maxX: 1179.0 / width: 393.0 = 3.0
        /// cappedProgress: 2.0
        /// maxX: 786.0 / width: 393.0 = 2.0
        /// cappedProgress: 1.0
        /// maxX: 393.0 / width: 393.0 = 1.0
        /// cappedProgress: 0.0

        /// Interpretation of Progress: With the -1.0 offset, the progress value becomes more intuitive for representing the scroll position. A negative value indicates the view is scrolled to the left beyond its visible region, 0.0 signifies the entire view is visible, and values closer to 1.0 represent the view being scrolled to the right with increasing portions hidden.
        
        /// return
        /// -1.0: View entirely scrolled to the left (completely hidden).
        /// 0.0: View fully visible within the scroll view.
        /// 1.0: View entirely scrolled to the right (completely hidden).
        
        let progress = (maxX / width) - 1.0
        let cappedProgress = min(progress, limit)

        return cappedProgress
        
    }
    
    func scale(_ proxy: GeometryProxy, scale: CGFloat = 0.1) -> CGFloat {
        let progress = progress(proxy)
        /// progress * scale: 0.2
        /// 1 - 0.2 = 0.8
        /// progress * scale: 0.1
        /// 1 - 0.1 = 0.9
        /// progress * scale: 0.0
        /// 1 - 0.0 = 1.0
        return 1 - (progress * scale)
    }
    
    func excessMinX(_ proxy: GeometryProxy, offset: CGFloat = 10) -> CGFloat {
        let progress = progress(proxy)
        /// progress * offset: 20.0
        /// progress * offset: 10.0
        /// progress * offset: 0.0
        return progress * offset
    }
    
    func rotation(_ proxy: GeometryProxy, rotation: CGFloat = 5) -> Angle {
        let progress = progress(proxy)
        /// progress * rotation: 10.0
        /// progress * rotation: 5.0
        /// progress * rotation: 0.0
        return .init(degrees: progress * rotation)
    }
}

#Preview {
    ContentView()
}
