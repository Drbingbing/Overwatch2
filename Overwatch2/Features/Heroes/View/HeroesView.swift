//
//  HeroesView.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/14.
//

import SwiftUI
import ComposableArchitecture

struct HeroesView: View {
    let store: StoreOf<HeroesStore>
    
    var body: some View {
        NavigationStack {
            WithViewStore(store, observe: { $0 }) { viewStore in
                HeroListView(heroes: viewStore.heroes) { hero in
                    viewStore.send(.selectedHero(hero))
                }
                .navigationTitle(Text("Heroes"))
                .background(Color(uiColor: .systemGray6))
                .toolbar {
                    ToolbarItem {
                        Menu {
                            ForEach(viewStore.roles, id: \.self) { role in
                                HStack {
                                    if role != "all" {
                                        Image(role)
                                    }
                                    Text(role.capitalized)
                                }
                                .onTap {
                                    viewStore.send(.searchHeroes(query: role == "all" ? nil : role))
                                }
                            }
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                        }
                        
                    }
                }
                .onAppear {
                    viewStore.send(.fetchHeroes)
                }
                .navigationDestination(
                    store: store.scope(
                        state: \.$destination,
                        action: { .destination($0) }
                    )
                ) { store in
                    HeroDetailView(store: store)
                }
            }
        }
    }
}

private struct HeroListView: View {
    var columns = [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20), GridItem(.flexible())]
    var heroes: [Hero]
    var onTap: (Hero) -> Void
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(heroes, id: \.name) { hero in
                    HeroCardView(hero: hero)
                        .onTap {
                            onTap(hero)
                        }
                        .id(hero.name)
                }
            }
            .animation(.spring(), value: heroes)
            .padding(20)
        }
    }
}

struct HeroesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HeroesView(
                store: Store(
                    initialState: HeroesStore.State(),
                    reducer: { HeroesStore() }
                )
            )
        }
    }
}
