//
//  ScheduleByDateResponse.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-07-16.
//
import Foundation

// MARK: - ScheduleByDateResponse
struct ScheduleByDateResponse: Codable, Identifiable {
    var id: Int { gameId }
    
    let gameId: Int
    let gameType: Int
    let gameState: String
    let venue: String
    let startTime: String
    let awayTeam: TeamInfo
    let homeTeam: TeamInfo
    let periodDescriptor: PeriodD
}

// MARK: - teamInfo
struct TeamInfo: Codable {
    let placeName: String
    let commonName: String
    let abbrev: String
    let darkLogo: String
    let score: Int?
}

// MARK: - PeriodD
struct PeriodD: Codable {
    let periodNum: Int?
    let periodType: String?
}
