//
//  MapsView.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/15.
//

import SwiftUI
import ComposableArchitecture

struct MapsView: View {
    
    var store: StoreOf<MapsStore>
    
    var body: some View {
        NavigationStack {
            WithViewStore(store, observe: { $0 }) { viewStore in
                MapGridView(
                    onTap: {
                        viewStore.send(.showMap($0))
                    },
                    maps: viewStore.maps
                )
            }
            .onAppear {
                store.send(.fetchMaps)
            }
            .navigationTitle(Text("Maps"))
            .background(Color(uiColor: .systemGray6))
            .sheet(
                store: store.scope(
                    state: \.$destination,
                    action: { .destination($0) }
                ),
                state: /MapsStore.Destination.State.showMap,
                action: MapsStore.Destination.Action.showMap
            ) {
                MapDetailView(store: $0)
            }
        }
        
    }
}

private struct MapGridView: View {
    
    var columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var onTap: (Map) -> Void
    var maps: [Map]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(maps, id: \.name) { map in
                    MapCardView(map: map)
                        .onTap {
                            onTap(map)
                        }
                        .id(map.name)
                }
            }
            .animation(.linear, value: maps)
            .padding(20)
        }
    }
}

struct MapsView_Previews: PreviewProvider {
    
    static var maps: [Map] {
        let file = Bundle.main.path(forResource: "maps_en", ofType: "json")!
        let path = URL(filePath: file)
        
        do {
            let data = try Data(contentsOf: path, options: .mappedIfSafe)
            return try JSONDecoder().decode([Map].self, from: data)
        } catch {
            return []
        }
    }
    
    static var previews: some View {
        MapsView(
            store: Store(
                initialState: MapsStore.State(),
                reducer: { MapsStore() }
            )
        )
    }
}
