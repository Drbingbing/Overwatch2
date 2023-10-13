//
//  GamemodeDetailView.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/19.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct GamemodeDetailView: View {
    
    var store: StoreOf<GamemodeDetailStore>
    var viewStore: ViewStoreOf<GamemodeDetailStore>
    
    init(store: StoreOf<GamemodeDetailStore>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        ScrollView {
            
            KFImage(URL(string: viewStore.mode.screenshot))
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            HStack {
                Text(viewStore.mode.name)
                    .font(.system(.title, design: .rounded, weight: .bold))
                Image(viewStore.mode.key + "_icon")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle(.blue)
                    .frame(width: 24, height: 24)

                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack {
                Text(viewStore.mode.description)
                    .foregroundStyle(Color.owGray2)
                    .font(.system(.body, design: .rounded, weight: .medium))
            }
            .padding(.horizontal, 20)
            
            WithViewStore(store, observe: { $0.maps }) { v in
                RelatedMaps(
                    onTap: { store.send(.showMap($0)) },
                    maps: v.state
                )
            }
        }
        .onAppear {
            store.send(.fetchMaps)
        }
        .ignoresSafeArea(edges: .top)
        .sheet(
            store: store.scope(
                state: \.$destination,
                action: { .destination($0) }),
            state: /GamemodeDetailStore.Destination.State.showMap,
            action: GamemodeDetailStore.Destination.Action.showMap
        ) {
            MapDetailView(store: $0)
        }
    }
}

private struct RelatedMaps: View {
    var onTap: (Map) -> Void
    var maps: [Map]
    
    var columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("地圖")
                    .foregroundStyle(.blue)
                    .font(.system(.title2, design: .rounded, weight: .medium))
                Spacer()
            }
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(maps, id: \.name) { map in
                    MapCardView(map: map)
                        .onTap { onTap(map) }
                        .id(map.name)
                }
            }
            .animation(.linear, value: maps)
            .padding(20)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
    }
}

#Preview {
    GamemodeDetailView(
        store: Store(
            initialState: GamemodeDetailStore.State(
                mode: Gamemode(
                    key: "assault",
                    name: "Assault",
                    icon: "https://overfast-api.tekrop.fr/static/gamemodes/assault-icon.svg",
                    description: "Teams fight to capture or defend two successive points against the enemy team. It's an inactive Overwatch 1 gamemode, also called 2CP.",
                    screenshot: "https://overfast-api.tekrop.fr/static/gamemodes/assault.avif"
                )
            ),
            reducer: { GamemodeDetailStore() }
        )
    )
}
