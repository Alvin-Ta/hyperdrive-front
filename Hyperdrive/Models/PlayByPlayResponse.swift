//
//  PlayByPlayResponse.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-09-17.
//
import Foundation

struct PlayByPlayResponse: Codable {
    let id: Int
    let season: Int
    let gameType: Int
    let gameDate: String
    let venue: String
    let venueLocation: String
    let startTimeUTC: String
    let gameState: String
    let periodDescriptor: PeriodDescriptor
    let awayTeam: Team1
    let homeTeam: Team1
    let clock: Clock
    let plays: [Plays]
    let rosterSpots: [RosterSpots]
}

struct Team1: Codable {
    let id: Int
    let commonName: String
    let abbrev: String
    let score: Int
    let sog: Int
    let logo: String
    let darkLogo: String
    let placeName: String
}

struct Plays: Codable {
    let eventId: Int
    let periodDescriptor: PeriodDescriptor
    let timeInPeriod: String
    let timeRemaining: String
    let situationCode: String
    let homeTeamDefendingSide: String
    let typeCode: Int
    let typeDescKey: String
    let sortOrder: Int
    let details: Details?
    let pptReplayUrl: String?
}

struct Details: Codable {
    let xCoord: Int?
    let yCoord: Int?
    let zoneCode: String?

    // General ownership
    let eventOwnerTeamId: Int?

    // Shot-related
    let shotType: String?
    let shootingPlayerId: Int?
    let goalieInNetId: Int?
    let awaySOG: Int?
    let homeSOG: Int?

    // Blocked shots
    let blockingPlayerId: Int?
    let reason: String?
    let secondaryReason: String?

    // Hits
    let hittingPlayerId: Int?
    let hitteePlayerId: Int?

    // Faceoffs
    let losingPlayerId: Int?
    let winningPlayerId: Int?

    // Giveaways/Takeaways
    let playerId: Int?

    // Penalties
    let typeCode: String?      // e.g., "MIN"
    let descKey: String?       // e.g., "high-sticking"
    let duration: Int?         // penalty minutes
    let committedByPlayerId: Int?
    let drawnByPlayerId: Int?

    // Goals
    let scoringPlayerId: Int?
    let scoringPlayerTotal: Int?
    let assist1PlayerId: Int?
    let assist1PlayerTotal: Int?
    let assist2PlayerId: Int?
    let assist2PlayerTotal: Int?
    let awayScore: Int?
    let homeScore: Int?
}

struct RosterSpots: Codable {
    let teamId: Int
    let playerId: Int
    let firstName: String
    let lastName: String
    let sweaterNumber: Int
    let positionCode: String
    let headshot: String
}
