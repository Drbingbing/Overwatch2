//
//  HeroesStore.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/14.
//

import Foundation
import ComposableArchitecture

struct HeroesStore: Reducer {
    
    @Dependency(\.heroClient) var heroClient
    
    struct State: Equatable {
        var heroes: [Hero] = []
        var roles: [String] = []
        @PresentationState var destination: HeroDetailStore.State?
    }
    
    enum Action {
        case heroesResponse(role: String, heroes: TaskResult<[Hero]>)
        case fetchHeroes
        case searchHeroes(query: String?)
        case destination(PresentationAction<HeroDetailStore.Action>)
        case selectedHero(Hero)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .heroesResponse(_, .failure):
                state.heroes = []
                state.roles = ["tank", "support", "damage"]
                return .none
            case let .heroesResponse(role, .success(heroes)):
                state.heroes = heroes
                state.roles = ["all", "tank", "support", "damage"].filter { $0 != role }
                return .none
            case .fetchHeroes:
                return .run { send in
                    await send(
                        .heroesResponse(
                            role: "all",
                            heroes: TaskResult { try await self.heroClient.fetchHeroes() }
                        )
                    )
                }
            case let .searchHeroes(query):
                return .run { send in
                    await send(
                        .heroesResponse(
                            role: query == nil ? "all" : query!,
                            heroes: TaskResult { await self.heroClient.searchHeroes(query) }
                        )
                    )
                }
            case .destination:
                return .none
            case let .selectedHero(hero):
                state.destination = HeroDetailStore.State(hero: hero)
                return .none
            }
        }
        .ifLet(\.$destination, action: /Action.destination) {
            HeroDetailStore()
        }
    }
}
