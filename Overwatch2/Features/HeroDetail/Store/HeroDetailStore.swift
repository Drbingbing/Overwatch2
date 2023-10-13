//
//  HeroDetailStore.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/14.
//

import Foundation
import ComposableArchitecture
import LinkPresentation

struct HeroDetailStore: Reducer {
    
    @Dependency(\.heroClient) var heroClient
    @Dependency(\.linkPresentationClient) var linkPresentationClient
    @Dependency(\.rolesClient) var rolesClient
    
    struct State: Equatable {
        var hero: Hero
        var otherHeroes: [Hero] = []
        var metaData: LPLinkMetadata? = nil
        @PresentationState var destination: Destination.State?
    }
    
    enum Action: Equatable {
        case fetchHero
        case heroResponse(TaskResult<Hero>)
        case otherHeroesResponse(TaskResult<[Hero]>)
        case selectOtherHero(Hero)
        case destination(PresentationAction<Destination.Action>)
        case mediaResponse(TaskResult<LPLinkMetadata>)
        case showAbility(Ability)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchHero:
                guard let key = state.hero.key else {
                    return .none
                }
                let role = state.hero.role
                return .run { send in
                    await send(.heroResponse(TaskResult { try await self.heroClient.heroInformation(key) }))
                    await send(.otherHeroesResponse(TaskResult { await self.heroClient.searchHeroes(role) }))
                }
            case let .heroResponse(.success(hero)):
                state.hero = hero
                if let media = hero.story?.media, let url = URL(string: media.link) {
                    return .run { send in
                        await send(.mediaResponse(TaskResult { try await self.linkPresentationClient.fetching(url) }))
                    }
                }
                return .none
            case let .otherHeroesResponse(.success(heroes)):
                state.otherHeroes = heroes.filter { $0.name != state.hero.name }
                return .none
            case .otherHeroesResponse(.failure), .heroResponse(.failure), .mediaResponse(.failure):
                return .none
            case let .selectOtherHero(hero):
                state.destination = .showHero(HeroDetailStore.State(hero: hero))
                return .none
            case let .mediaResponse(.success(metaData)):
                state.metaData = metaData
                return .none
            case .destination:
                return .none
            case let .showAbility(ability):
                state.destination = .showAbility(AbilityStore.State(ability: ability))
                return .none
            }
        }
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
    }
}

extension HeroDetailStore {
    
    struct Destination: Reducer {
        
        enum State: Equatable {
            case showHero(HeroDetailStore.State)
            case showAbility(AbilityStore.State)
        }
        
        enum Action: Equatable {
            case showHero(HeroDetailStore.Action)
            case showAbility(AbilityStore.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.showHero, action: /Action.showHero) {
                HeroDetailStore()
            }
            Scope(state: /State.showAbility, action: /Action.showAbility) {
                AbilityStore()
            }
        }
    }
}
