//
//  PlayerClient.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/10/5.
//

import Foundation
import Dependencies

struct PlayerClient {
    var fetchPlayer: () async throws -> Player
}

extension PlayerClient: DependencyKey {
    
    static var liveValue: PlayerClient = PlayerClient(
        fetchPlayer: {
            let url = URL(string: "https://overfast-api.tekrop.fr/players/曹丕媳婦進菜園-3360")!
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(Player.self, from: data)
        }
    )
}

extension PlayerClient: TestDependencyKey {
    static var previewValue: PlayerClient = PlayerClient(
        fetchPlayer: {
            let file = Bundle.main.path(forResource: "player", ofType: "json")!
            let data = try Data(contentsOf: URL(filePath: file), options: .mappedIfSafe)
            return try JSONDecoder().decode(Player.self, from: data)
        }
    )
}

extension DependencyValues {
    
    var playerClient: PlayerClient {
        get { self[PlayerClient.self] }
        set { self[PlayerClient.self] = newValue }
    }
}
