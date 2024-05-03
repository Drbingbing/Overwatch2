//
//  Map.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/15.
//

import Foundation

struct Map: Codable, Equatable {
    
    var name: String
    var screenshot: String
    var gameModes: [String]
    var location: String
    var countryCode: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case screenshot = "screenshot"
        case gameModes = "gamemodes"
        case location = "location"
        case countryCode = "country_code"
    }
}
