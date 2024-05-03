//
//  Gamemode.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/19.
//

import Foundation

struct Gamemode: Codable, Equatable {
    var key: String
    var name: String
    var icon: String
    var description: String
    var screenshot: String
}
