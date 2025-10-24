//
//  PlayerInfoResponse.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-09-05.
//

import Foundation

struct PlayerInfoResponse: Codable {
    let playerId: Int
    let isActive: Bool
    let currentTeamId: Int
    let currentTeamAbbrev: String
    let fullTeamName: String
    let teamCommonName: String
    let firstName: String
    let lastName: String
    let teamLogo: String
    let sweaterNumber: Int
    let position: String
    let headshot: String
    let weightInPounds: Int
    let weightInKilograms: Int
    let birthDate: String
    let birthCity: String
    let birthStateProvince: String
    let birthCountry: String
    let draftDetails: draftDetails
    let featuredStats: featuredStats
    let careerTotals: careerTotals
    let last5Games: [last5Games]
    let nhlSeasons: [nhlSeasons]
}

struct draftDetails: Codable {
    let year: Int
    let teamAbbrev: String
    let round: Int
    let pickInRound: Int
    let overallPick: Int
}

struct featuredStats: Codable {
    let season: Int
    let regularSeason: szn
//    let playoffs: szn
}

struct szn: Codable {
    let curSeason: stats
    let career: stats
}

struct stats: Codable {
    let assists: Int
    let gamesPlayed: Int
    let goals: Int
    let otGoals: Int
    let pim: Int
    let plusMinus: Int
    let points: Int
    let powerPlayGoals: Int
    let powerPlayPoints: Int
    let shootingPctg: Double
    let shots: Int
}

struct careerTotals: Codable {
    let regularSeason: careerStats
    let playoffs: careerStats?
}

struct careerStats: Codable {
    let assists: Int
    let avgToi: String
    let faceoffWinningPctg: Double
    let gameWinningGoals: Int
    let gamesPlayed: Int
    let goals: Int
    let otGoals: Int
    let pim: Int
    let plusMinus: Int
    let points: Int
    let powerPlayGoals: Int
    let powerPlayPoints: Int
    let shootingPctg: Double
    let shots: Int
}

struct last5Games: Codable {
    let assists: Int
    let gameDate: String
    let gameId: Int
    let gameTypeId: Int
    let goals: Int
    let homeRoadFlag: String
    let opponentAbbrev: String
    let pim: Int
    let plusMinus: Int
    let points: Int
    let powerPlayGoals: Int
    let shifts: Int
    let shorthandedGoals: Int
    let shots: Int
    let teamAbbrev: String
    let toi: String
}

struct nhlSeasons: Codable {
    let assists: Int
    let avgToi: String
    let faceoffWinningPctg: Double
    let gamesPlayed: Int
    let goals: Int
    let otGoals: Int
    let pim: Int
    let plusMinus: Int
    let points: Int
    let powerPlayGoals: Int
    let powerPlayPoints: Int
    let shootingPctg: Double
    let shots: Int
    let season: Int
    let teamName: String
    let teamCommonName: String
}


