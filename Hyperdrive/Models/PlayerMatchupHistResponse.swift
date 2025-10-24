//
//  pla.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-07-16.
//

import Foundation

struct PlayerMatchupHistResponse: Codable {
    let gameId: Int
    let teamAbbrev: String
    let homeRoadFlag: String
    let gameDate: String
    let goals: Int
    let assists: Int
    let commonName: CommonName
    let opponentCommonName: CommonName
    //goalie
    let gamesStarted: Int?
    let decision: String?
    let shotsAgainst: Int?
    let goalsAgainst: Int?
    let savePctg: Double?
    let shutouts: Int?
    //goalie
    let points: Int?
    let plusMinus: Int?
    let powerPlayGoals: Int?
    let powerPlayPoints: Int?
    let gameWinningGoals: Int?
    let otGoals: Int?
    let shots: Int?
    let shifts: Int?
    let shorthandedGoals: Int?
    let shorthandedPoints: Int?
    let opponentAbbrev: String
    let pim: Int
    let toi: String
}

// MARK: - CommonName
struct CommonName: Codable {
    let `default`: String
}
