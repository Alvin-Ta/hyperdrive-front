//
//  PlayerGameLogResponse.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-07-13.
//

import Foundation

struct PlayerGameLogResponse: Codable {
    let seasonId, gameTypeId: Int
    let playerStatsSeasons: [playerStatsSeason]
    let gameLog: [GameLog]
}

struct playerStatsSeason: Codable {
    let season: Int
    let gameTypes: [Int]
}

struct GameLog: Codable {
    let gameId: Int
    let teamAbbrev: String
    let homeRoadFlag: homeRoadFlag
    let gameDate: String
    let goals: Int
    let assists: Int
//    let teamName: String
//    let opponentName: String
    let points: Int
    let plusMinus: Int
    let powerPlayGoals: Int
    let powerPlayPoints: Int
    let gameWinningGoals: Int
    let otGoals: Int
    let shots: Int
    let shifts: Int
    let shorthandedGoals: Int
    let shorthandedPoints: Int
    let opponentAbbrev: String
    let pim: Int
    let toi: String
}

// MARK: - HomeRoadFlag
enum homeRoadFlag: String, Codable {
    case home = "H"
    case road = "R"
}

enum CodingKeys: String, CodingKey {
    case gameId
    case teamAbbrev
    case homeRoadFlag
    case gameDate
    case goals
    case assists
//    case teamName = "commonName"
//    case opponentName = "opponentCommonName"
    case points
    case plusMinus
    case powerPlayGoals
    case powerPlayPoints
    case gameWinningGoals
    case otGoals
    case shots
    case shifts
    case shorthandedGoals
    case shorthandedPoints
    case opponentAbbrev
    case pim
    case toi
}
