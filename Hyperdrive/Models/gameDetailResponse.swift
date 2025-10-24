//
//  gameDetailResponse.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-07-25.
//

import Foundation

// MARK: - gameDetailResponse
struct gameDetailResponse: Codable {
    let gameDetails: gameDetails
    
}

struct gameDetails: Codable {
    let gameId, season, gameType: Int
    let gameDate, startTime, venue, venueLocation: String
    let periodDescriptor: PeriodDescriptor1?
    let gameState: String
    let regPeriods: Int
    
    let awayTeam: gdTeam
    let homeTeam: gdTeam
    let summary: gameSummary
    let matchup: Matchup?
    let clock: clockValues?
}

struct gdTeam: Codable {
    let id: Int
    let commonName, abbrev, placeName, cityName, darkLogo, logo: String
    let score: Int?
    let sog: Int?
    let record: String?
    
}

struct PeriodDescriptor1: Codable {
    let number: Int
    let periodType: String
    let maxRegulationPeriods: Int
}

struct gameSummary: Codable {
    let scoring: [ScoringPeriod]
    let penalties: [Penalty]
    let threeStars: [ThreeStar]
}

struct ScoringPeriod: Codable {
    let periodDescriptor: PeriodDescriptor1
    let goals: [Goal]
}

struct Goal: Codable {
    let playerId: Int
    let name: nameFields
    let teamAbbrev: String
    let headshot: String
    let highlightClipSharingUrl: String?
    let highlightClipSharingUrlFr: String?
    let goalsToDate: Int
    let awayScore: Int
    let homeScore: Int
    let leadingTeamAbbrev: String?
    let timeInPeriod: String
    let shotType: String
    let goalModifier: String
    let assists: [Assist]
    let pptReplayUrl: String
}

struct Assist: Codable {
    let playerId: Int
    let name: nameFields
    let assistsToDate: Int
    let sweaterNumber: Int
}

struct nameFields: Codable {
    let firstName: String
    let lastName: String
}

struct Penalty: Codable {
    let timeInPeriod: String
    let type: String
    let duration: Int
    let descKey: String
    let committedByPlayer: String
    let teamAbbrev: String
    let drawnBy: String?
}

struct ThreeStar: Codable {
    let star: Int
    let playerId: Int
    let teamAbbrev: String
    let headshot: String
    let name: PlayerName
    let sweaterNo: Int
    let position: String
    let goalsAgainstAverage: Double?
    let savePctg: Double?
    let goals: Int?
    let assists: Int?
    let points: Int?
}

struct PlayerName: Codable {
    let `default`: String
}


struct Matchup: Codable {
    let skaterSeasonStats: SkaterSeasonStats?
    let goalieSeasonStats: GoalieSeasonStats?
}


struct SkaterSeasonStats: Codable {
    let contextLabel: String
    let contextSeason: Int?
    let skaters: [skater]
}

struct skater: Codable {
    let playerId: Int
    let teamId: Int?
    let sweaterNumber: Int?
    let name: String
    let position: String
    let gamesPlayed: Int?
    let goals: Int?
    let assists: Int?
    let points: Int?
    let plusMinus: Int?
    let pim: Int?
    let avgPoints: Double?
    let avgTimeOnIce: String?
    let gameWinningGoals: Int?
    let shots: Int?
    let shootingPctg: Double?
    let faceoffWinningPctg: Double?
    let powerPlayGoals: Int?
    let blockedShots: Int?
    let hits: Int?
}

struct GoalieSeasonStats: Codable {
    let contextLabel: String
    let contextSeason: Int?
    let goalies: [goalieStats]
}

struct goalieStats: Codable {
    let playerId: Int
    let teamId: Int?
    let sweaterNumber: Int?
    let name: String
    let gamesPlayed: Int?
    let wins: Int?
    let losses: Int?
    let otLosses: Int?
    let shotsAgainst: Int?
    let goalsAgainst: Int?
    let goalsAgainstAvg: Double?
    let savePctg: Double?
    let shutouts: Int?
    let saves: Int?
    let toi: String?
}

// MARK: - Clock
struct clockValues: Codable {
    let timeRemaining: String
    let secondsRemaining: Int
    let running: Bool
    let inIntermission: Bool
}

