//
//  GameDetailsViewModel.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-07-17.
//

import Foundation
import Combine

class GameDetailsViewModel: ObservableObject {
    @Published var games: gameDetailResponse?
    @Published var boxscore: BoxScoreResponse?
    @Published var matchup: TeamVsTeamRecordResponse?
    @Published var awayPlayers: [getPlayersResponse] = []
    @Published var homePlayers: [getPlayersResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchGame(for gameId: String) {
        isLoading = true
        errorMessage = nil

        HyperdriveService.shared.getGameDetails(gameId: gameId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let games):
//                    print(games.gameDetails)
                    self?.games = games
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchPlayers(for abbrev: String, isHome: Bool) {
        isLoading = true
        errorMessage = nil

        HyperdriveService.shared.getPlayers(team: abbrev) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let players):
                    if isHome {
//                        print(players)
                        self?.homePlayers = players

                    }
                    else{
                        self?.awayPlayers = players
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchPreviousMatchup(for team: String, opponent: String, season: String){
        isLoading = true
        errorMessage = nil
        
        HyperdriveService.shared.getTeamVsTeamRecord(team: team, opponent: opponent, season: season){ [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let matchup):
//                    print(matchup.record)
                    self?.matchup = matchup
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchBoxscore(for gameId: String) {
        isLoading = true
        errorMessage = nil

        HyperdriveService.shared.getBoxScore(gameId: gameId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let boxscore):
//                    print(boxscore.boxScore)
                    self?.boxscore = boxscore
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
}
