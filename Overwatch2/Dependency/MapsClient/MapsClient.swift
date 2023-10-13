//
//  MapsClient.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/18.
//

import Foundation
import Dependencies

struct MapsClient {
    
    fileprivate static var cachedMaps: [Map] = []
    
    var fetchMaps: (String?) async throws -> [Map]
}

extension MapsClient: DependencyKey {
    
    static var liveValue: MapsClient = MapsClient(
        fetchMaps: { gameMode in
            
            let query = [URLQueryItem(name: "gamemode", value: gameMode), URLQueryItem(name: "locale", value: "zh-tw")]
            var component = URLComponents()
            component.path = "/maps"
            component.queryItems = query.filter { $0.value != nil}
            component.host = "overfast-api.tekrop.fr"
            component.scheme = "https"
            let (data, _) = try await URLSession.shared.data(from: component.url!)
            return try JSONDecoder().decode([Map].self, from: data)
        }
    )
}

extension MapsClient: TestDependencyKey {
    
    static var previewValue: MapsClient = MapsClient(
        fetchMaps: { _ in
            let file = Bundle.main.path(forResource: "maps_en", ofType: "json")!
            let path = URL(filePath: file)
            
            do {
                let data = try Data(contentsOf: path, options: .mappedIfSafe)
                cachedMaps = try JSONDecoder().decode([Map].self, from: data)
                return cachedMaps
            } catch {
                return []
            }
        }
    )
}


extension DependencyValues {
    var mapsClient: MapsClient {
        get { self[MapsClient.self] }
        set { self[MapsClient.self] = newValue }
    }
}
