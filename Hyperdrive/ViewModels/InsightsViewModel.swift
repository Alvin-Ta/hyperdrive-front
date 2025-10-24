//
//  InsightsViewModel.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-07-17.
//

import Foundation
import Combine

class InsightsViewModel: ObservableObject {
    @Published var players: [AllPlayersResponse] = []
    @Published var matchupHist: [PlayerMatchupHistResponse] = []
    @Published var gameLog: PlayerGameLogResponse?
    @Published var playerInfo: PlayerInfoResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    
    func fetchPlayers() {
        isLoading = true
        errorMessage = nil
        
        HyperdriveService.shared.getAllPlayers() { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let players):
//                    print(players) //uncomment for debugging
                    self?.players = players
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchMatchupHist(for playerId: String, opponent: String) {
        isLoading = true
        errorMessage = nil
        
        HyperdriveService.shared.getPlayerMatchupHist(playerId: playerId, opponent: opponent) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let matchups):
//                    print(matchups) //uncomment for debugging
                    self?.matchupHist = matchups
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchPlayerGameLog(for playerId: String, season: String, gameType: Int) {
        isLoading = true
        errorMessage = nil

        HyperdriveService.shared.getPlayerGameLog(playerId: playerId, season: season, gameType: gameType) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let gamelog):
                    //print(gamelog.gameLog)//uncomment for debugging
                    self?.gameLog = gamelog
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchPlayerInfo(for playerId: String) {
        isLoading = true
        errorMessage = nil

        HyperdriveService.shared.getPlayerInfo(playerId: playerId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let playerInfo):
//                    print(playerInfo.isActive) //uncomment for debugging
                    self?.playerInfo = playerInfo
                case .failure(let error):
//                    print("Failed")
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
