//
//  AllPlayersResponse.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-08-29.
//

import Foundation

struct AllPlayersResponse: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let sweaterNumber: Int?
    let headshot: String
    let teamAbbrev: String
    let teamName: String
    let teamLogo: String
    let position: String
    let value: Int
    
    var displayName: String { "\(firstName) \(lastName)" }
}

