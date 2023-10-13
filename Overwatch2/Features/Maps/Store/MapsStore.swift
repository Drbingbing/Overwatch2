//
//  MapsStore.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/18.
//

import Foundation
import ComposableArchitecture

struct MapsStore: Reducer {
    
    @Dependency(\.mapsClient) var client: MapsClient
    
    struct State: Equatable {
        var maps: [Map] = []
        @PresentationState var destination: Destination.State?
    }
    
    enum Action {
        case fetchMaps
        case mapsResponse(TaskResult<[Map]>)
        case showMap(Map)
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchMaps:
                return .run { send in
                    await send(
                        .mapsResponse(TaskResult { try await self.client.fetchMaps(nil) })
                    )
                }
            case let .mapsResponse(.success(maps)):
                state.maps = maps
                return .none
            case .mapsResponse(.failure):
                return .none
            case .destination(.presented(.showMap(.closeMap))):
                state.destination = nil
                return .none
            case .destination:
                return .none
            case let .showMap(map):
                state.destination = .showMap(MapDetailStore.State(map: map))
                return .none
            }
        }
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
    }
}

extension MapsStore {
    
    struct Destination: Reducer {
        
        enum State: Equatable {
            case showMap(MapDetailStore.State)
        }
        
        enum Action: Equatable {
            case showMap(MapDetailStore.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.showMap, action: /Action.showMap) {
                MapDetailStore()
            }
        }
    }
}
