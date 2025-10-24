//
//  helpers.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-09-10.
//
import SwiftUI


func formatDate(_ input: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")

    if let date = inputFormatter.date(from: input) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MM/dd/yy"
        return outputFormatter.string(from: date)
    } else {
        return input // fallback if parsing fails
    }
}

enum PlayKind: String {
    case goal = "goal"
    case shotOnGoal = "shot-on-goal"
    case missedShot = "missed-shot"
    case blockedShot = "blocked-shot"
    case faceoff = "faceoff"
    case giveaway = "giveaway"
    case hit = "hit"
    case stoppage = "stoppage"
    case periodStart = "period-start"
    case periodEnd = "period-end"
    case gameEnd = "game-end"
    case unknown
    
    init(key: String) {
        self = PlayKind(rawValue: key) ?? .unknown
    }
}

extension Plays {
    var kind: PlayKind { PlayKind(key: typeDescKey) }
}
