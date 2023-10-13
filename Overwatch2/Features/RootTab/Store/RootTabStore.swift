//
//  RootTabStore.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/14.
//

import ComposableArchitecture

enum TabBarItem: Int, Identifiable {
    case heros
    case maps
    case mode
    case profile
    
    var id: Int { rawValue }
}

struct RootTabStore: Reducer {
    
    @Dependency(\.rolesClient) var rolesClient
    
    struct State: Equatable {
        var tabs: [TabBarItem] = [.heros, .maps, .mode, .profile]
        var currentTab: TabBarItem = .heros
    }
    
    enum Action {
        case fetchRoles
        case selectTab(TabBarItem)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .selectTab(tab):
            state.currentTab = tab
            return .none
        case .fetchRoles:
            return .run { send in
                _ = try await self.rolesClient.fetchRoles()
            }
        }
    }
}
