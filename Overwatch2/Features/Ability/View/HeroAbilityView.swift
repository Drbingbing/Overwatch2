//
//  HeroAbilityView.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/15.
//

import SwiftUI
import AVKit
import Kingfisher
import ComposableArchitecture

struct HeroAbilityView: View {
    
    var store: StoreOf<AbilityStore>
    
    var player = AVPlayer(url: URL(string: "https://assets.blz-contentstack.com/v3/assets/blt2477dcaf4ebd440c/blt35fa57c9d35027cf/6339047eed7dcc6a00280398/OVERWATCH_WEBSITE_CHARACTER_CAPTURE_AnaSleepDart_WEB_16x9_1920x1080p30_H264.mp4")!)
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            VideoPlayer(player: viewStore.player)
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        
                        HStack(spacing: 12) {
                            KFImage(URL(string: viewStore.ability.icon))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                                .padding(10)
                                .background(.secondary)
                                .clipShape(Circle())
                            VStack(alignment: .leading, spacing: 6) {
                                Text(viewStore.ability.name)
                                    .foregroundColor(.white)
                                    .font(.system(.body, design: .rounded, weight: .medium))
                                Text(viewStore.ability.description)
                                    .font(.system(.body, design: .rounded))
                                    .foregroundColor(Color(hex: "E9ECEF"))
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                    }
                }
                .background(.black)
                .onAppear {
                    viewStore.send(.play)
                }
                .onChange(of: viewStore.player) { newValue in
                    if let newValue {
                        addRepeat(for: newValue)
                        newValue.play()
                    }
                }
        }
    }
    
    private func addRepeat(for player: AVPlayer) {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { _ in
            player.seek(to: .zero)
            player.play()
        }
    }
}

//struct HeroAbilityView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeroAbilityView(store: <#StoreOf<AbilityStore>#>)
//            .frame(height: 400)
//            .previewLayout(.sizeThatFits)
//    }
//}
