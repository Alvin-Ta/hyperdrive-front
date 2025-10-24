//
//  TeamVsTeamRecordResponse.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-07-16.
//

import Foundation

struct TeamVsTeamRecordResponse: Codable {
    let team: String
    let opponent: String
    let season: String
    let record: [record]
}

struct record: Codable {
    let id: Int
    let gameDate: String
    let venue: String
    let gameState: String
    let awayTeam: Team
    let homeTeam: Team
    let periodDescription: PeriodDescription
}

struct Team: Codable {
    let id: Int
    let commonName: String
    let placeName: String
    let abbrev: String
    let darkLogo: String
    let awayScore: Int
}

struct PeriodDescription: Codable {
    let maxRegulationPeriods: Int
}


