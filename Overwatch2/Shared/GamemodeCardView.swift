//
//  GamemodeCardView.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/19.
//

import SwiftUI
import Kingfisher

struct GamemodeCardView: View {
    
    var mode: Gamemode
    
    var body: some View {
        VStack(spacing: 8) {
            KFImage(URL(string: mode.screenshot))
                .resizable()
                .scaledToFit()
                .frame(minWidth: 80, minHeight: 80)
            HStack(alignment: .center, spacing: 4) {
                Text(mode.name.uppercased())
                    .lineLimit(1)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .minimumScaleFactor(0.01)
            }
            .padding(.horizontal, 4)
        }
        .padding(.bottom, 8)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.15),radius: 4)
    }
}

#Preview {
    GamemodeCardView(
        mode: Gamemode(
            key: "assault",
            name: "Assault",
            icon: "https://overfast-api.tekrop.fr/static/gamemodes/assault-icon.svg",
            description: "Teams fight to capture or defend two successive points against the enemy team. It's an inactive Overwatch 1 gamemode, also called 2CP.",
            screenshot: "https://overfast-api.tekrop.fr/static/gamemodes/assault.avif"
        )
    )
    .previewLayout(.sizeThatFits)
}
