//
//  GamemodeClient.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/19.
//

import Foundation
import Dependencies

struct GamemodeClient {
    
    var fetchModes: () async throws -> [Gamemode]
}

extension GamemodeClient: DependencyKey {
    
    static var liveValue: GamemodeClient = GamemodeClient(
        fetchModes: {
            let url = URL(string: "https://overfast-api.tekrop.fr/gamemodes?locale=zh-tw")!
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([Gamemode].self, from: data)
        }
    )
}

extension GamemodeClient: TestDependencyKey {
    
    static var previewValue: GamemodeClient = GamemodeClient(
        fetchModes: {
            let file = Bundle.main.path(forResource: "gamemode_zh", ofType: "json")!
            let data = try Data(contentsOf: URL(filePath: file), options: .mappedIfSafe)
            return try JSONDecoder().decode([Gamemode].self, from: data)
        }
    )
}

extension DependencyValues {
    
    var gamemodeClient: GamemodeClient {
        get { self[GamemodeClient.self] }
        set { self[GamemodeClient.self] = newValue }
    }
}
