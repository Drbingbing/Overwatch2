//
//  TopHeroesStore.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/10/12.
//

import Foundation
import ComposableArchitecture

struct TopHeroesStore: Reducer {
    
    enum Filter: String, CaseIterable, Hashable {
        case timePlayed = "Time Played"
        case gamesWon = "Games Won"
        case weaponAccuracy = "Weapon Accuracy"
        case elimanationsPerLife = "Elimanations Per Life"
        case criticalHitAccuracy = "Critical Hit Accuracy"
        case multiKillBest = "Multikill-Best"
        case objectiveKills = "Objective Kills"
    }
    
    struct State: Equatable {
        var heroesComparisons: PlatformStats.GamePlayKind.HeroesComparisons
        var currentFilter: Filter = .timePlayed
        var selectedComparisons: [PlatformStats.GamePlayKind.HeroComparisons.Value] = []
        var showAll = false
    }
    
    enum Action: Equatable {
        case setup
        case selectFilter(Filter)
        case showAll(Bool)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .setup:
                state.currentFilter = .timePlayed
                state.selectedComparisons = (state.heroesComparisons
                    .timePlayed?.values ?? [])
                    .prefix(4)
                    .sorted(by: { $0.value > $1.value })
                    .map { $0 }
                return .none
            case let .selectFilter(filter):
                state.currentFilter = filter
                var all: [PlatformStats.GamePlayKind.HeroComparisons.Value]
                switch filter {
                case .timePlayed:
                    all = state.heroesComparisons.timePlayed?.values ?? []
                case .gamesWon:
                    all = state.heroesComparisons.gamesWon?.values ?? []
                case .weaponAccuracy:
                    all = state.heroesComparisons.weaponAccuracy?.values ?? []
                case .elimanationsPerLife:
                    all = state.heroesComparisons.eliminationsPerLife?.values  ?? []
                case .criticalHitAccuracy:
                    all = state.heroesComparisons.criticalHitAccuracy?.values  ?? []
                case .multiKillBest:
                    all = state.heroesComparisons.multikillBest?.values  ?? []
                case .objectiveKills:
                    all = state.heroesComparisons.objectiveKills?.values  ?? []
                }
                state.selectedComparisons = all
                    .prefix(state.showAll ? all.count : 4)
                    .sorted(by: { $0.value > $1.value })
                    .map { $0 }
                    
                return .none
            case let .showAll(showAll):
                state.showAll = showAll
                return .send(.selectFilter(state.currentFilter))
            }
        }
    }
}
