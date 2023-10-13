//
//  MapDetailStore.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/19.
//

import Foundation
import ComposableArchitecture

struct MapDetailStore: Reducer {
    
    struct State: Equatable {
        var map: Map
    }
    
    enum Action: Equatable {
        case closeMap
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .closeMap:
                return .none
            }
        }
    }
}
