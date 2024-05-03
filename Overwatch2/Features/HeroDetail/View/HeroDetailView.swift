//
//  HeroDetailView.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/14.
//

import ComposableArchitecture
import SwiftUI
import LinkPresentation

struct HeroDetailView: View {
    
    var store: StoreOf<HeroDetailStore>
    @ObservedObject var viewStore: ViewStoreOf<HeroDetailStore>
    
    init(store: StoreOf<HeroDetailStore>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    var body: some View {
        ScrollView {
            DescriptionView(
                name: viewStore.hero.name,
                portrait: viewStore.hero.portrait,
                description: viewStore.hero.description,
                role: viewStore.hero.role,
                location: viewStore.hero.location,
                onTap: {  }
            )
            
            if let abilities = viewStore.hero.abilities {
                AbilityView(abilities: abilities) { ability in
                    viewStore.send(.showAbility(ability))
                }
            }
            
            if let hitPoint = viewStore.hero.hitpoints {
                HitPointView(hitPoint: hitPoint)
            }
            
            if let story = viewStore.hero.story {
                StoryView(story: story, metaData: viewStore.metaData)
            }
            
            if !viewStore.otherHeroes.isEmpty {
                OtherHeroesView(heroes: viewStore.otherHeroes) { hero in
                    viewStore.send(.selectOtherHero(hero))
                }
                .animation(.linear, value: viewStore.otherHeroes)
                .transition(.opacity)
            }
            
        }
        .animation(.easeInOut, value: viewStore.hero)
        .background(Color(uiColor: .systemGray6))
        .onAppear {
            viewStore.send(.fetchHero)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(
            store: store.scope(
                state: \.$destination,
                action: { .destination($0) }
            ),
            state: /HeroDetailStore.Destination.State.showHero,
            action: HeroDetailStore.Destination.Action.showHero
        ) { store in
            HeroDetailView(store: store)
        }
        .sheet(
            store: store.scope(
                state: \.$destination,
                action: { .destination($0) }
            ),
            state: /HeroDetailStore.Destination.State.showAbility,
            action: HeroDetailStore.Destination.Action.showAbility
        ) { store in
            HeroAbilityView(store: store)
                .presentationDetents([.medium])
        }
    }
}

private struct DescriptionView: View {
    
    var name: String
    var portrait: String
    var description: String?
    var role: String
    var location: String?
    var onTap: (() -> Void)?
    
    var body: some View {
        
        VStack {
            HStack(spacing: 8) {
                AsyncImage(url: URL(string: portrait)) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .cornerRadius(60)
                            .frame(width: 120, height: 120)
                            .padding(4)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.15), radius: 4)
                    }
                }
                .onTap { onTap?() }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(name)
                        .foregroundColor(.owBlack)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                    if let description {
                        Text(description)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.owGray2)
                    }
                }
            }
            .padding(20)
            
            VStack(spacing: 12) {
                HStack {
                    Image("icon_\(role)")
                        .resizable()
                        .foregroundColor(Color.secondary)
                        .frame(width: 16, height: 16)
                        .padding(6)
                        .background(.secondary.opacity(0.5))
                        .clipShape(Circle())
                    Text(role.displayName.capitalized)
                        .foregroundColor(.owGray2)
                        .font(.system(.body, design: .rounded))
                    Spacer()
                }
                
                if let location {
                    HStack {
                        Image("location")
                            .resizable()
                            .foregroundColor(Color.secondary)
                            .frame(width: 16, height: 16)
                            .padding(6)
                            .background(.secondary.opacity(0.5))
                            .clipShape(Circle())
                        Text(location.capitalized)
                            .foregroundColor(.owGray2)
                            .font(.system(.body, design: .rounded))
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

private struct AbilityView: View {
    
    var abilities: [Ability]
    var onTap: (Ability) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("技能")
                .font(.system(.title3, design: .rounded, weight: .medium))
                .foregroundColor(.blue)
                .padding(.leading, 4)
            
            VStack(spacing: 12) {
                ForEach(abilities, id: \.name) { ability in
                    HStack(alignment: .top) {
                        AsyncImage(url: URL(string: ability.icon)) { phase in
                            if let image = phase.image {
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 32, height: 32)
                                    .padding(6)
                                    .background(.secondary)
                                    .clipShape(Circle())
                            }
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(ability.name)
                                .foregroundColor(.owBlack)
                                .font(.system(.body, design: .rounded, weight: .medium))
                            Text(ability.description)
                                .foregroundColor(.owGray2)
                        }
                        Spacer()
                    }
                    .padding(12)
                    .background(.regularMaterial)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.15), radius: 4)
                    .onTap { onTap(ability) }
                }
            }
         }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}

private struct HitPointView: View {
    
    var hitPoint: HitPoint
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("數值")
                .font(.system(.title3, design: .rounded, weight: .medium))
                .foregroundColor(.blue)
                .padding(.leading, 4)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center, spacing: 4) {
                    Text("藍盾:")
                        .foregroundColor(.secondary)
                    Text("\(hitPoint.shields)")
                        .foregroundColor(.owBlack)
                        .font(.system(.body, design: .rounded))
                    Spacer()
                }
                HStack(alignment: .center, spacing: 4) {
                    Text("黃甲:")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.secondary)
                    Text("\(hitPoint.armor)")
                        .foregroundColor(.owBlack)
                        .font(.system(.body, design: .rounded))
                    Spacer()
                }
                HStack(alignment: .center, spacing: 4) {
                    Text("血量:")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.secondary)
                    Text("\(hitPoint.health)")
                        .foregroundColor(.owBlack)
                        .font(.system(.body, design: .rounded))
                    Spacer()
                }
                HStack(alignment: .center, spacing: 4) {
                    Text("總生命值:")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.secondary)
                    Text("\(hitPoint.total)")
                        .foregroundColor(.owBlack)
                        .font(.system(.body, design: .rounded))
                    Spacer()
                }
            }
            .padding(12)
            .background(.regularMaterial)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.15), radius: 4)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}

private struct StoryView: View {
    
    var story: Story
    var metaData: LPLinkMetadata?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            Text("出生來歷")
                .font(.system(.title3, design: .rounded, weight: .medium))
                .foregroundColor(.blue)
                .padding(.leading, 4)
            
            VStack(spacing: 20) {
                
                VStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("概要")
                            .foregroundColor(.owBlack)
                            .font(.system(.headline, design: .rounded, weight: .medium))
                        Text(story.summary)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.owGray2)
                    }
                    
                    if let metaData {
                        LinkPreview(metaData: metaData)
                    }
                }
                .animation(.easeInOut, value: metaData)
                .transition(.opacity)
                
                ForEach(story.chapters, id: \.title) { chapter in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(chapter.title)
                            .foregroundColor(.owBlack)
                            .font(.system(.headline, design: .rounded, weight: .medium))
                        Text(chapter.content)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.owGray2)
                    }
                }
            }
            .padding(12)
            .background(.regularMaterial)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.15), radius: 4)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}

private struct OtherHeroesView: View {
    
    var heroes: [Hero]
    var onTap: (Hero) -> Void
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            Text("其他英雄")
                .font(.system(.title3, design: .rounded, weight: .medium))
                .foregroundColor(.blue)
                .padding(.leading, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.flexible(), spacing: 12)]) {
                    ForEach(heroes, id: \.name) { hero in
                        HeroCardView(hero: hero)
                            .onTap {
                                onTap(hero)
                            }
                            .id(hero.name)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
            }
            .frame(height: 160)
        }
    }
}

struct HeroDetailView_Previews: PreviewProvider {
    
    private static var initialHero: Hero {
        let json: [String: Any] = [
            "key": "ana",
            "name": "Ana",
            "portrait": "https://d15f34w2p8l1cc.cloudfront.net/overwatch/3429c394716364bbef802180e9763d04812757c205e1b4568bc321772096ed86.png",
            "role": "support"
        ]
        
        do {
            let json = try JSONSerialization.data(withJSONObject: json)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Hero.self, from: json)
        } catch {
            fatalError("missing files")
        }
    }
    
    static var previews: some View {
        NavigationStack {
            HeroDetailView(
                store: Store(
                    initialState: HeroDetailStore.State(hero: initialHero),
                    reducer: { HeroDetailStore() }
                )
            ).navigationBarTitleDisplayMode(.inline)
        }
    }
}
