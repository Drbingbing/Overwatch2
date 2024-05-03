//
//  TopHeroesView.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/10/5.
//

import SwiftUI
import ComposableArchitecture

struct TopHeroesView: View {
    
    var store: StoreOf<TopHeroesStore>
    
    init(heroesComparisons: PlatformStats.GamePlayKind.HeroesComparisons) {
        self.store = Store(
            initialState: TopHeroesStore.State(heroesComparisons: heroesComparisons),
            reducer: { TopHeroesStore() }
        )
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Top Heroes".uppercased())
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                Spacer()
                WithViewStore(store, observe: \.currentFilter) { viewStore in
                    Menu {
                        Picker(
                            "Filtered by",
                            selection: viewStore.binding(send: TopHeroesStore.Action.selectFilter)
                        ) {
                            ForEach(TopHeroesStore.Filter.allCases, id: \.self) { filter in
                                Text(filter.rawValue).tag(filter)
                            }
                        }
                    } label: {
                        Text(viewStore.state.rawValue)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                    }
                    .foregroundStyle(.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            .padding(.horizontal, 20)
            
            WithViewStore(store, observe: { $0 }) { viewStore in
                HeroChartsView(
                    label: viewStore.currentFilter.rawValue,
                    heroes: viewStore.selectedComparisons,
                    showAll: viewStore.binding(
                        get: { $0.showAll },
                        send: TopHeroesStore.Action.showAll
                    ).animation()
                )
            }
        }
        .padding(.vertical, 20)
        .background(.regularMaterial)
        .padding(.vertical, 12)
        .onAppear {
            store.send(.setup)
        }
    }
    
    
}


#Preview {
    ScrollView {
        TopHeroesView(
            heroesComparisons: .init(
                timePlayed: .init(label: "Time Played", values: [.init(hero: "ana", value: 200)]),
                gamesWon: .init(label: "Time Played", values: [.init(hero: "cassidy", value: 200)]),
                weaponAccuracy: .init(label: "Time Played", values: []),
                winPercentage: .init(label: "Time Played", values: []),
                eliminationsPerLife: .init(label: "Time Played", values: []),
                criticalHitAccuracy: .init(label: "Time Played", values: []),
                multikillBest: .init(label: "Time Played", values: []),
                objectiveKills: .init(label: "Time Played", values: [])
            )
        )
    }
    .background {
        LinearGradient(
            colors: [Color(hex: "ABC4FF"), Color(hex: "E2EAFC")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
