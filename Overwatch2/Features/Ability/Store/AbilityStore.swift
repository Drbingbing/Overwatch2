//
//  AbilityStore.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/15.
//

import Foundation
import AVKit
import ComposableArchitecture

struct AbilityStore: Reducer {
    
    struct State: Equatable {
        var ability: Ability
        var player: AVPlayer?
    }
    
    enum Action: Equatable {
        case play
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .play:
                if let url = URL(string: state.ability.video.link.mp4) {
                    state.player = AVPlayer(url: url)
                }
                return .none
            }
        }
    }
}
