//
//  RoleClient.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/18.
//

import Foundation
import Dependencies

struct RoleClient {
    
    private(set) static var cachedRoles: [Role] = []
    
    var fetchRoles: () async throws -> [Role]
}

extension RoleClient: DependencyKey {
    static var liveValue: RoleClient = RoleClient(
        fetchRoles: {
            guard cachedRoles.isEmpty else {
                return cachedRoles
            }
            let url = URL(string: "https://overfast-api.tekrop.fr/roles?locale=zh-tw")!
            let (data, _) = try await URLSession.shared.data(from: url)
            cachedRoles = try JSONDecoder().decode([Role].self, from: data)
            return cachedRoles
        }
    )
}

extension DependencyValues {
    var rolesClient: RoleClient {
        get { self[RoleClient.self] }
        set { self[RoleClient.self] = newValue }
    }
}
