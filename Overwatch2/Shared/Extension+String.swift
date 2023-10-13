//
//  Extension+String.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/15.
//

import Foundation

extension String {
    
    var flag: String {
        let base : UInt32 = 127397
        var s = ""
        for v in self.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    var displayName: String {
        let roles = RoleClient.cachedRoles
        if let matched = roles.first(where: { $0.key == self }) {
            return matched.name
        }
        return self
    }
}
