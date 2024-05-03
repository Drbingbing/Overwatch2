//
//  HeroCardView.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/15.
//

import SwiftUI
import Kingfisher

struct HeroCardView: View {
    
    var hero: Hero
    
    var body: some View {
        VStack(spacing: 8) {
            KFImage(URL(string: hero.portrait))
                .resizable()
                .scaledToFit()
                .cornerRadius(10, corners: [.topLeft, .topRight])
                .frame(minWidth: 80, minHeight: 80)
            HStack(alignment: .center, spacing: 4) {
                Image(hero.role)
                    .resizable()
                    .frame(width: 16, height: 16)
                Text(hero.name.uppercased())
                    .lineLimit(1)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .minimumScaleFactor(0.01)
            }
            .padding(.horizontal, 4)
        }
        .padding(4)
        .padding(.bottom, 4)
        .background(.regularMaterial)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.15),radius: 4)
    }
}

struct SimpleHeroView_Previews: PreviewProvider {
    
    private static var initialHero: Hero {
        let file = Bundle.main.path(forResource: "ana", ofType: "json")!
        let path = URL(filePath: file)
        
        do {
            let data = try Data(contentsOf: path, options: .mappedIfSafe)
            return try JSONDecoder().decode(Hero.self, from: data)
        } catch {
            fatalError("missing files")
        }
    }
    
    static var previews: some View {
        HeroCardView(hero: initialHero)
            .frame(width: 120)
    }
}
