//
//  MapCardView.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/15.
//

import SwiftUI
import Kingfisher

struct MapCardView: View {
    
    var map: Map
    
    var body: some View {
        VStack(spacing: 8) {
            KFImage(URL(string: map.screenshot))
                .resizable()
                .scaledToFit()
                .frame(minWidth: 80, minHeight: 80 * 9/16)
            HStack(alignment: .center, spacing: 4) {
                if let countryCode = map.countryCode {
                    Text(countryCode.flag)
                }
                Text(map.name.uppercased())
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

struct MapCardView_Previews: PreviewProvider {
    
    private static var map: Map {
        Map(
            name: "Hanamura",
            screenshot: "https://overfast-api.tekrop.fr/static/maps/hanamura.jpg",
            gameModes: ["assault"],
            location: "Tokyo, Japan",
            countryCode: "JP"
        )
    }
    
    static var previews: some View {
        MapCardView(map: map)
//            .frame(width: 120)
            .previewLayout(.sizeThatFits)
    }
}
