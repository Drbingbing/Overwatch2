//
//  Player.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/10/4.
//

import Foundation

// MARK: - Welcome
struct Player: Codable, Equatable {
    let summary: Summary
    let stats: PlatformStats
}

// MARK: - Summary
struct Summary: Codable, Equatable {
    let username: String
    let avatar, namecard: String
    let title: String
    let endorsement: Endorsement
    let competitive: SummaryCompetitive
    let privacy: String
    
    
    // MARK: - Endorsement
    struct Endorsement: Codable, Equatable {
        let level: Int
        let frame: String
    }

    // MARK: - SummaryCompetitive
    struct SummaryCompetitive: Codable, Equatable {
        let pc: CompetitivePlatform?
        let console: CompetitivePlatform?
    }

    // MARK: - CompetitivePC
    struct CompetitivePlatform: Codable, Equatable {
        let season: Int
        let tank: CompetitiveRole?
        let damage: CompetitiveRole?
        let support: CompetitiveRole?
    }

    // MARK: - Role
    struct CompetitiveRole: Codable, Equatable {
        let division: String
        let tier: Int
        let roleIcon: String
        let rankIcon: String

        enum CodingKeys: String, CodingKey {
            case division, tier
            case roleIcon = "role_icon"
            case rankIcon = "rank_icon"
        }
    }

}

// MARK: - Stats
struct PlatformStats: Codable, Equatable {
    let pc: Stats?
    let console: Stats?
    
    // MARK: - StatsPC
    struct Stats: Codable, Equatable {
        let quickplay, competitive: GamePlayKind?
    }
    
    
    
    // MARK: - QuickplayClass
    struct GamePlayKind: Codable, Equatable {
        let heroesComparisons: HeroesComparisons
        let careerStats: [String: [CareerStat]?]

        enum CodingKeys: String, CodingKey {
            case heroesComparisons = "heroes_comparisons"
            case careerStats = "career_stats"
        }
        
        // MARK: - CareerStat
        struct CareerStat: Codable, Equatable {
            let category: Category
            let label: Label
            let stats: [Stat]
        }
        
        
        enum Category: String, Codable {
            case assists = "assists"
            case average = "average"
            case best = "best"
            case combat = "combat"
            case game = "game"
            case heroSpecific = "hero_specific"
            case matchAwards = "match_awards"
        }

        enum Label: String, Codable {
            case assists = "Assists"
            case average = "Average"
            case best = "Best"
            case combat = "Combat"
            case game = "Game"
            case heroSpecific = "Hero Specific"
            case matchAwards = "Match Awards"
        }
        
        // MARK: - Stat
        struct Stat: Codable, Equatable {
            let key, label: String
            let value: Double
        }
        
        
        // MARK: - HeroesComparisons
        struct HeroesComparisons: Codable, Equatable {
            let timePlayed, gamesWon, weaponAccuracy: HeroComparisons
            let winPercentage: HeroComparisons?
            let eliminationsPerLife, criticalHitAccuracy, multikillBest, objectiveKills: HeroComparisons

            enum CodingKeys: String, CodingKey {
                case timePlayed = "time_played"
                case gamesWon = "games_won"
                case weaponAccuracy = "weapon_accuracy"
                case winPercentage = "win_percentage"
                case eliminationsPerLife = "eliminations_per_life"
                case criticalHitAccuracy = "critical_hit_accuracy"
                case multikillBest = "multikill_best"
                case objectiveKills = "objective_kills"
            }
        }

        
        // MARK: - CriticalHitAccuracy
        struct HeroComparisons: Codable, Equatable {
            let label: String
            let values: [Value]
            
            
            // MARK: - Value
            struct Value: Codable, Equatable {
                let hero: String
                let value: Double
            }
        }
    }
}


