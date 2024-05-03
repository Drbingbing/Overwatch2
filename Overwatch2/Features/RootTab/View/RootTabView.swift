//
//  ContentView.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/13.
//

import SwiftUI
import ComposableArchitecture

struct RootTabView: View {
    let store: StoreOf<RootTabStore>
    init() {
        self.store = Store(initialState: RootTabStore.State()) { RootTabStore() }
    }
    
    @State var selectedIndex = 0
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            TabView(selection: $selectedIndex) {
                ForEach(viewStore.tabs) { tab in
                    TabContentView(tab: tab)
                        .tabItem {
                            Label(title(forTab: tab), systemImage: imageName(forTab: tab))
                        }
                        
                }
            }
            .onAppear {
                viewStore.send(.fetchRoles)
            }
        }
    }
    
    private func imageName(forTab tab: TabBarItem) -> String {
        switch tab {
        case .heros:
            return "person.2"
        case .maps:
            return "map"
        case .mode:
            return "gamecontroller"
        case .profile:
            return "gear"
        }
    }
    
    private func title(forTab tab: TabBarItem) -> String {
        switch tab {
        case .heros:
            return "Heroes"
        case .maps:
            return "Maps"
        case .mode:
            return "Modes"
        case .profile:
            return "Profile"
        }
    }
}

private struct TabContentView: View {
    
    var tab: TabBarItem
    
    var body: some View {
        switch tab {
        case .heros:
            HeroesView(
                store: Store(
                    initialState: HeroesStore.State(),
                    reducer: { HeroesStore() }
                )
            )
        case .maps:
            MapsView(
                store: Store(
                    initialState: MapsStore.State(),
                    reducer: { MapsStore() }
                )
            )
        case .mode:
            GamemodeView(
                store: Store(
                    initialState: GamemodesStore.State(),
                    reducer: { GamemodesStore() }
                )
            )
        case .profile:
            ProfileView(
                store: Store(
                    initialState: ProfileStore.State(),
                    reducer: { ProfileStore() }
                )
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView()
    }
}
