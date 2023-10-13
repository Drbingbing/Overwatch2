//
//  GamemodesStore.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/19.
//

import Foundation
import ComposableArchitecture

struct GamemodesStore: Reducer {
    
    @Dependency(\.gamemodeClient) var client
    
    struct State: Equatable {
        var modes: [Gamemode] = []
        @PresentationState var destination: Destination.State?
    }
    
    enum Action: Equatable {
        case fetchModes
        case modesResponse(TaskResult<[Gamemode]>)
        case showMode(Gamemode)
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchModes:
                return .run { send in
                    await send(
                        .modesResponse(TaskResult { try await client.fetchModes() })
                    )
                }
            case .modesResponse(.failure):
                return .none
            case let .modesResponse(.success(modes)):
                state.modes = modes
                return .none
            case .destination:
                return .none
            case let .showMode(mode):
                state.destination = .showMode(GamemodeDetailStore.State(mode: mode))
                return .none
            }
        }
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
    }
}

extension GamemodesStore {
    
    struct Destination: Reducer {
        
        enum State: Equatable {
            case showMode(GamemodeDetailStore.State)
        }
        
        enum Action: Equatable {
            case showMode(GamemodeDetailStore.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.showMode, action: /Action.showMode) {
                GamemodeDetailStore()
            }
        }
    }
}
