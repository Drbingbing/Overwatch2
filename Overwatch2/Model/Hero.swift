//
//  Hero.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/9/14.
//

import Foundation

struct Hero: Codable, Equatable {
    var key: String?
    var name: String
    var portrait: String
    var role: String
    
    var description: String?
    var location: String?
    var hitpoints: HitPoint?
    var abilities: [Ability]?
    var story: Story?
}

struct HitPoint: Codable, Equatable {
    
    var health: Int
    var armor: Int
    var shields: Int
    var total: Int
}

struct Ability: Codable, Equatable {
    
    struct Video: Codable, Equatable {
        var thumbnail: String
        var link: Link
    }
    
    struct Link: Codable, Equatable {
        var mp4: String
        var webm: String
    }
    
    var name: String
    var description: String
    var icon: String
    var video: Video
}


struct Story: Codable, Equatable {
    
    struct Media: Codable, Equatable {
        var type: String
        var link: String
    }
    
    struct Chapters: Codable, Equatable {
        var title: String
        var content: String
        var picture: String
    }
    
    var summary: String
    var media: Media
    var chapters: [Chapters]
}
