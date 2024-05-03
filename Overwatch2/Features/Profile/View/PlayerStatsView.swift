//
//  PlayerStatsView.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/10/12.
//

import SwiftUI
import SDWebImageSwiftUI
import SDWebImageSVGCoder

struct PlayerStatsView: View {
    
    var summary: Summary
    private var rank: Summary.CompetitivePlatform?
    
    init(summary: Summary, platform: Platform) {
        self.summary = summary
        switch platform {
        case .pc:
            self.rank = summary.competitive.pc
        case .console:
            self.rank = summary.competitive.console
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack(alignment: .top, spacing: 12) {
                    WebImage(
                        url: URL(string: summary.avatar)
                    )
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
                    .padding(4)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(summary.username)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                        HStack {
                            Text(summary.title)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.orange)
                            WebImage(url: URL(string: summary.endorsement.frame))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 48)
                            
                        }
                    }
                }
                
                if let rank {
                    
                    HStack(spacing: 20) {
                        if let tank = rank.tank {
                            RankView(icon: "icon_tank", url: tank.rankIcon)
                        }
                        
                        if let damage = rank.damage {
                            RankView(icon: "icon_damage", url: damage.rankIcon)
                        }
                        
                        if let support = rank.support {
                            RankView(icon: "icon_support", url: support.rankIcon)
                        }
                    }
                    .padding(.horizontal, 32)
                }
            }
        }
    }
}

private struct RankView: View {
    
    var icon: String
    var url: String
    
    var body: some View {
        HStack {
            
            Image(icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32)
            
            WebImage(url: URL(string: url))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48)
            
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color(hex: "ABC4FF"), Color(hex: "E2EAFC")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        PlayerStatsView(
            summary: .init(
                username: "曹丕媳婦進菜園",
                avatar: "https://d15f34w2p8l1cc.cloudfront.net/overwatch/7b28c4f87aa9c23c42c90e3d0e3f2ed26e36c6b917c8f07c0d437702ea7a0dae.png",
                namecard: "https://d15f34w2p8l1cc.cloudfront.net/overwatch/59fd62bca585b43d480d8c4868f40309e1eda3d1a73955f1396847d9d562aad8.png",
                title: "Vulture",
                endorsement: .init(level: 2, frame: "https://static.playoverwatch.com/img/pages/career/icons/endorsement/2-8b9f0faa25.svg#icon"),
                competitive: .init(
                    pc: .init(
                        season: 6,
                        tank: .init(
                            division: "platinum",
                            tier: 3,
                            roleIcon: "https://static.playoverwatch.com/img/pages/career/icons/role/tank-f64702b684.svg#icon",
                            rankIcon: "https://static.playoverwatch.com/img/pages/career/icons/rank/PlatinumTier-3-e6885ae77f.png"
                        ),
                        damage: nil,
                        support: .init(
                            division: "master",
                            tier: 4,
                            roleIcon: "https://static.playoverwatch.com/img/pages/career/icons/role/support-0258e13d85.svg#icon",
                            rankIcon: "https://static.playoverwatch.com/img/pages/career/icons/rank/MasterTier-4-397f8722e0.png"
                        )
                    ),
                    console: nil
                ),
                privacy: "public"
            ),
            platform: .pc
        )
    }
}
