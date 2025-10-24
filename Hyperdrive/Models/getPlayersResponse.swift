//
//  getPlayersResponse.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-07-16.
//

import Foundation

struct getPlayersResponse: Codable {
        let playerId: Int
        let firstName: String
        let lastName: String
        let headshot: String
        let jerseyNum: Int?
        let position: String
}
//struct player: Codable {
//    let playerId: Int
//    let firstName: String
//    let lastName: String
//    let headshot: String
//    let jerseyNum: Int?
//    let position: String
//}
