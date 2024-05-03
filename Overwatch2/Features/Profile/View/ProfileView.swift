//
//  ProfileView.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/25.
//

import SwiftUI
import SDWebImageSwiftUI
import SDWebImageSVGCoder
import ComposableArchitecture

struct ProfileView: View {
    
    var store: StoreOf<ProfileStore>
    
    var emptyView: some View {
        VStack {
            Color.clear.frame(height: 20)
            Text("WE DON'T HAVE ANY DATA FOR THIS ACCOUNT IN THIS MODE YET.")
                .padding(.horizontal, 20)
                .font(.system(size: 20, weight: .bold, design: .rounded))
        }
    }
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "ABC4FF"), Color(hex: "E2EAFC")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                WithViewStore(store, observe: { $0 }) { viewStore in
                    
                    ScrollView(showsIndicators: false) {
                        if viewStore.isLoading {
                            Color.clear.frame(height: 100)
                            ActivityIndicator(.constant(true))
                        }
                        if let summary = viewStore.summary {
                            PlayerStatsView(summary: summary, platform: viewStore.platform)
                        }
                        if let heroesComparisons = viewStore.heroesComparisons, let careerStats = viewStore.careerStat {
                            TopHeroesView(heroesComparisons: heroesComparisons)
                            CareerStatsView(careerStats: careerStats)
                        } else if !viewStore.isLoading {
                            emptyView
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItemGroup {
                            Picker(
                                "Platform",
                                selection: viewStore.binding(
                                    get: { $0.platform },
                                    send: ProfileStore.Action.selectPlatform
                                )
                            ) {
                                ForEach(Platform.allCases, id: \.self) { platform in
                                    Label(platform.displayName, systemImage: platform.displayImage)
                                        .tag(platform)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .disabled(viewStore.isLoading)
                            
                            Picker(
                                "Game play mode",
                                systemImage: "ellipsis.circle",
                                selection: viewStore.binding(
                                    get: { $0.gamePlayMode },
                                    send: ProfileStore.Action.selectGameMode
                                )
                            ) {
                                ForEach(GamePlayMode.allCases, id: \.self) { mode in
                                    Text(mode.rawValue)
                                        .tag(mode)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .colorMultiply(.black)
                        }
                    }
                    .onAppear {
                        store.send(.fetchPlayer)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView(
        store: .init(
            initialState: ProfileStore.State(),
            reducer: { ProfileStore() }
        )
    )
    .onAppear {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }
}
