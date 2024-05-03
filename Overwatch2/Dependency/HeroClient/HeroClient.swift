//
//  HeroClient.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/14.
//

import Foundation
import Dependencies

struct HeroClient {
    
    // store in memory
    fileprivate static var cachedHeroes: [Hero] = []
    
    var fetchHeroes: () async throws -> [Hero]
    var searchHeroes: (String?) async -> [Hero]
    var heroInformation: (String) async throws -> Hero
}

extension HeroClient: DependencyKey {
    
    static let liveValue = HeroClient(
        fetchHeroes: {
            guard HeroClient.cachedHeroes.isEmpty else {
                return HeroClient.cachedHeroes
            }
            let url = URL(string: "https://overfast-api.tekrop.fr/heroes?locale=zh-tw&")!
            let (data, _) = try await URLSession.shared.data(from: url)
            HeroClient.cachedHeroes = try JSONDecoder().decode([Hero].self, from: data)
            return HeroClient.cachedHeroes
        },
        searchHeroes: { query in
            if let query {
                return HeroClient.cachedHeroes.filter { $0.role == query }
            }
            return HeroClient.cachedHeroes
        },
        heroInformation: { key in
            let url = URL(string: "https://overfast-api.tekrop.fr/heroes/\(key)?locale=zh-tw")!
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(Hero.self, from: data)
        }
    )
}

extension HeroClient: TestDependencyKey {
    static var previewValue = HeroClient(
        fetchHeroes: { Hero.mocks() },
        searchHeroes: { query in
            if let query {
                return Hero.mocks().filter { $0.role == query }
            }
            return Hero.mocks()
        },
        heroInformation: { key in
            return Hero.mock()
        }
    )
}

extension DependencyValues {
    var heroClient: HeroClient {
        get { self[HeroClient.self] }
        set { self[HeroClient.self] = newValue }
    }
}

private extension Hero {
    
    static func mocks() -> [Hero] {
        if HeroClient.cachedHeroes.count > 0 {
            return HeroClient.cachedHeroes
        }
        
        let file = Bundle.main.path(forResource: "heroes_en", ofType: "json")!
        let path = URL(filePath: file)
        
        do {
            let data = try Data(contentsOf: path, options: .mappedIfSafe)
            HeroClient.cachedHeroes = try JSONDecoder().decode([Hero].self, from: data)
            return HeroClient.cachedHeroes
        } catch {
            return []
        }
    }
    
    static func mock() -> Hero {
        let file = Bundle.main.path(forResource: "ana", ofType: "json")!
        let path = URL(filePath: file)
        
        do {
            let data = try Data(contentsOf: path, options: .mappedIfSafe)
            return try JSONDecoder().decode(Hero.self, from: data)
        } catch {
            fatalError("missing files")
        }
    }
}
