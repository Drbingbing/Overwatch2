//
//  ProfileStore.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/10/12.
//

import Foundation
import ComposableArchitecture

struct ProfileStore: Reducer {
    
    @Dependency(\.playerClient) var client
    
    struct State: Equatable {
        var player: Player?
        var careerStat: [String : [PlatformStats.GamePlayKind.CareerStat]?]?
        var heroesComparisons: PlatformStats.GamePlayKind.HeroesComparisons?
        var platform: Platform = .pc
        var isLoading: Bool = false
        var summary: Summary?
        var gamePlayMode: GamePlayMode = .quickplay
    }
    
    enum Action: Equatable {
        case fetchPlayer
        case playerResponse(TaskResult<Player>)
        case selectPlatform(Platform)
        case selectGameMode(GamePlayMode)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchPlayer:
                state.isLoading = true
                return .run { send in
                    await send(.playerResponse(TaskResult { try await self.client.fetchPlayer() }))
                }
            case let .playerResponse(.success(player)):
                state.player = player
                state.summary = player.summary
                state.heroesComparisons = player.stats.pc?.quickplay?.heroesComparisons
                state.careerStat = player.stats.pc?.quickplay?.careerStats
                state.isLoading = false
                return .none
            case .playerResponse(.failure):
                state.isLoading = false
                return .none
            case let .selectPlatform(platform):
                state.platform = platform
                switch platform {
                case .console:
                    switch state.gamePlayMode {
                    case .competitive:
                        state.careerStat = state.player?.stats.console?.competitive?.careerStats
                        state.heroesComparisons = state.player?.stats.console?.competitive?.heroesComparisons
                    case .quickplay:
                        state.careerStat = state.player?.stats.console?.quickplay?.careerStats
                        state.heroesComparisons = state.player?.stats.console?.quickplay?.heroesComparisons
                    }
                    
                case .pc:
                    switch state.gamePlayMode {
                    case .competitive:
                        state.heroesComparisons = state.player?.stats.pc?.competitive?.heroesComparisons
                        state.careerStat = state.player?.stats.pc?.competitive?.careerStats
                    case .quickplay:
                        state.heroesComparisons = state.player?.stats.pc?.quickplay?.heroesComparisons
                        state.careerStat = state.player?.stats.pc?.quickplay?.careerStats
                    }
                }
                return .none
            case let .selectGameMode(mode):
                state.gamePlayMode = mode
                return .send(.selectPlatform(state.platform))
            }
        }
    }
}
