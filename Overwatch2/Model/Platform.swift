//
//  Platform.swift
//  Overwatch2
//
//  Created by 鍾秉辰 on 2023/10/12.
//

import Foundation

enum Platform: String, CaseIterable, Hashable {
    case pc = "pc", console = "console"
    var displayName: String {
        switch self {
        case .pc:
            return "PC"
        case .console:
            return "Console"
        }
    }
    var displayImage: String {
        switch self {
        case .pc:
            return "display"
        case .console:
            return "gamecontroller"
        }
    }
}
