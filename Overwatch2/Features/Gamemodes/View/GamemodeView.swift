//
//  GamemodeView.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/19.
//

import SwiftUI
import ComposableArchitecture

struct GamemodeView: View {
    
    var store: StoreOf<GamemodesStore>
    
    var body: some View {
        NavigationStack {
            WithViewStore(store, observe: { $0 }) { viewStore in
                ModeGridView(
                    onTap: {
                        viewStore.send(.showMode($0))
                    },
                    modes: viewStore.modes
                )
            }
            .onAppear {
                store.send(.fetchModes)
            }
            .navigationTitle(Text("Game Modes"))
            .background(Color(uiColor: .systemGray6))
            .navigationDestination(
                store: store.scope(
                    state: \.$destination,
                    action: { .destination($0) }),
                state: /GamemodesStore.Destination.State.showMode,
                action: GamemodesStore.Destination.Action.showMode
            ) {
                GamemodeDetailView(store: $0)
            }
        }
        
    }
}

private struct ModeGridView: View {
    
    var columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var onTap: (Gamemode) -> Void
    var modes: [Gamemode]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(modes, id: \.name) { mode in
                    GamemodeCardView(mode: mode)
                        .onTap {
                            onTap(mode)
                        }
                        .id(mode.name)
                }
            }
            .animation(.linear, value: modes)
            .padding(20)
        }
    }
}


#Preview {
    GamemodeView(
        store: Store(
            initialState: GamemodesStore.State(),
            reducer: { GamemodesStore() }
        )
    )
}
