//
//  Models.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-07-09.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)
import Foundation

// MARK: - BoxScoreResponse
struct BoxScoreResponse: Codable {
    let boxScore: BoxScore
    let topPerformers: TopPerformers
}

// MARK: - BoxScore
struct BoxScore: Codable {
    let gameID, gameType: Int
    let gameDate, venue, venueLocation, gameState: String
    let periodDescriptor: PeriodDescriptor
    let homeTeam, awayTeam: BoxScoreTeam
    let clock: Clock
    let playerByGameStats: PlayerByGameStats

    enum CodingKeys: String, CodingKey {
        case gameID = "gameId"
        case gameType, gameDate, venue, venueLocation, gameState, periodDescriptor, homeTeam, awayTeam, clock, playerByGameStats
    }
}

// MARK: - BoxScoreTeam
struct BoxScoreTeam: Codable {
    let id: Int
    let commonName: Name
    let abbrev: String
    let score, sog: Int
    let logo, darkLogo: String
    let placeName: Name
    let placeNameWithPreposition: PlaceNameWithPreposition
}

// MARK: - Name
struct Name: Codable {
    let nameDefault: String

    enum CodingKeys: String, CodingKey {
        case nameDefault = "default"
    }
}

// MARK: - PlaceNameWithPreposition
struct PlaceNameWithPreposition: Codable {
    let placeNameWithPrepositionDefault, fr: String

    enum CodingKeys: String, CodingKey {
        case placeNameWithPrepositionDefault = "default"
        case fr
    }
}

// MARK: - Clock
struct Clock: Codable {
    let timeRemaining: String
    let secondsRemaining: Int
    let running, inIntermission: Bool
}

// MARK: - PeriodDescriptor
struct PeriodDescriptor: Codable {
    let number: Int
    let periodType: String
    let maxRegulationPeriods: Int
}

// MARK: - PlayerByGameStats
struct PlayerByGameStats: Codable {
    let awayTeam, homeTeam: TeamPlayerStats
}

// MARK: - TeamPlayerStats
struct TeamPlayerStats: Codable {
    let forwards, defense: [Skater]
    let goalies: [Goalie]
}

// MARK: - Skater
struct Skater: Codable {
    let playerID, sweaterNumber: Int
    let name: Name
    let position: Position
    let goals, assists, points, plusMinus: Int
    let pim, hits, powerPlayGoals, sog: Int
    let faceoffWinningPctg: Double
    let toi: String
    let blockedShots, shifts, giveaways, takeaways: Int

    enum CodingKeys: String, CodingKey {
        case playerID = "playerId"
        case sweaterNumber, name, position, goals, assists, points, plusMinus, pim, hits, powerPlayGoals, sog, faceoffWinningPctg, toi, blockedShots, shifts, giveaways, takeaways
    }
}

enum Position: String, Codable {
    case c = "C"
    case d = "D"
    case l = "L"
    case r = "R"
}

// MARK: - Goalie
struct Goalie: Codable {
    let playerID, sweaterNumber: Int
    let name: Name
    let position, evenStrengthShotsAgainst, powerPlayShotsAgainst, shorthandedShotsAgainst: String
    let saveShotsAgainst: String
    let savePctg: Double?
    let evenStrengthGoalsAgainst, powerPlayGoalsAgainst, shorthandedGoalsAgainst: Int
    let goalsAgainst: Int
    let toi: String
//    let starter: Bool
    let decision: String?
    let shotsAgainst, saves: Int

    enum CodingKeys: String, CodingKey {
        case playerID = "playerId"
        case sweaterNumber, name, position, evenStrengthShotsAgainst, powerPlayShotsAgainst, shorthandedShotsAgainst, saveShotsAgainst, savePctg, evenStrengthGoalsAgainst, powerPlayGoalsAgainst, shorthandedGoalsAgainst, goalsAgainst, toi, decision, shotsAgainst, saves
    }
}

// MARK: - TopPerformers
struct TopPerformers: Codable {
    let homeTeamName: String
    let homeTeam: [Skater]
    let awayTeamName: String
    let awayTeam: [Skater]
}
