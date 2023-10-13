//
//  OffsetObserving.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/10/4.
//

import SwiftUI

struct ScrollViewWithOffset<Content: View>: View {

    public init(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        offset: Binding<CGPoint>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self._offset = offset
        self.content = content
    }

    @Binding private var offset: CGPoint
    private let axes: Axis.Set
    private let showsIndicators: Bool
    private let content: () -> Content

    var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            ScrollViewOffsetTracker()
            content()
        }
        .offsetTracking { offset in
            self.offset = CGPoint(x: -offset.x, y: -offset.y)
        }
    }
}

private extension ScrollView {
    
    func offsetTracking(
        action: @escaping (_ offset: CGPoint) -> Void
    ) -> some View {
        self
            .coordinateSpace(name: ScrollOffsetNamespace.namespace)
            .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: action)
    }
}

private enum ScrollOffsetNamespace {
    
    static let namespace = "scrollView"
}

private struct ScrollViewOffsetTracker: View {
    
    var body: some View {
        GeometryReader { geo in
            Color.clear
                .preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: geo.frame(in: .named(ScrollOffsetNamespace.namespace)).origin
                )
        }
        .frame(height: 0)
    }
}

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}
