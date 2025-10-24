//
//  PreviousMatchesResponse.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-07-15.
//

import Foundation

struct PreviousMatchesResponse: Codable {
    let previousMatches: [previousMatch]
}

struct previousMatch: Codable {
    let id: Int
    let gameDate: String
    let venue: String
    let gameState: String
    let awayTeam: team
    let homeTeam: team
    let periodDescription: pDescription
}

struct team: Codable {
    let id: Int
    let commonName: String
    let placeName: String
    let abbrev: String
    let darkLogo: String
}

struct pDescription: Codable {
    let maxRegulationPeriods: Int
}
