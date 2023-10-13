//
//  MapDetailView.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/19.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct MapDetailView: View {
    var store: StoreOf<MapDetailStore>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack(alignment: .topTrailing) {
                
                GeometryReader { proxy in
                    KFImage(URL(string: viewStore.map.screenshot))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .pinchAndZoom(size: proxy.size)
                }
                
                Button(action: { viewStore.send(.closeMap) }) {
                    Image(systemName: "xmark")
                        .foregroundStyle(.gray)
                        .padding(8)
                        .background(.regularMaterial)
                        .clipShape(Circle())
                }
                .buttonStyle(.scaled)
                .padding([.trailing, .top], 12)
            }
        }
    }
}

#Preview {
    MapDetailView(
        store: Store(
            initialState: MapDetailStore.State(
                map: Map(
                    name: "Hanamura",
                    screenshot: "https://overfast-api.tekrop.fr/static/maps/hanamura.jpg",
                    gameModes: ["assault"],
                    location: "Tokyo, Japan",
                    countryCode: "JP"
                )
            ),
            reducer: { MapDetailStore() }
        )
    )
}
