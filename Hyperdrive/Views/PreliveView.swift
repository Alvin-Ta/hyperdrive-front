//
//  GameDetailView.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-07-23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PreliveView: View {
    @StateObject var viewModel = GameDetailsViewModel()
    let gameId: String
    let home: String
    let away: String

    var body: some View {
        VStack(spacing: 16) {
            VStack {
                HStack{
                    if let game = viewModel.games?.gameDetails {
                        Spacer()
                        VStack(spacing: 15) {
                            WebImage(url: URL(string: game.awayTeam.darkLogo))
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 70)

                            Text(game.awayTeam.record ?? "nil")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack (spacing: 8){
                            Text("vs")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text(formatDate(game.gameDate))
                                .font(.caption2)
                        }
                        Spacer()
                        VStack(spacing: 15) {
                            WebImage(url: URL(string: game.homeTeam.darkLogo))
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 70)
                            Text(game.homeTeam.record ?? "nil")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.white)
                        }
                        Spacer()

                    }
                    
                    else {
                        Text("🏒 Loading Matchup")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                }
                
                .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 90)
            .padding(.vertical, 20)
            .background(Color(red: 26/255, green: 26/255, blue: 29/255))

            
            
            // Scrollable Body
            ScrollView {
                VStack(spacing: 12) {
                    if viewModel.isLoading {
                        ProgressView("Loading game...")
                    } else if let error = viewModel.errorMessage {
                        Text("❌ Error: \(error)")
                            .foregroundColor(.red)
                    } else if let game = viewModel.games?.gameDetails {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Previous Matchups")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 14) {
                                    ForEach(viewModel.matchup?.record ?? [], id: \.id) { matchup in
                                        VStack{
                                            HStack() {
                                                Text("\(matchup.awayTeam.awayScore)")
                                                    .font(.title)
                                                    .foregroundColor(.white)
                                                Text("-")
                                                    .font(.title)
                                                    .foregroundColor(.white)
                                                Text("\(matchup.homeTeam.awayScore)")
                                                    .font(.title)
                                                    .foregroundColor(.white)
                                            }
                                            if (matchup.awayTeam.awayScore > matchup.homeTeam.awayScore) {
                                                Text("\(matchup.awayTeam.abbrev) W")
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                            }
                                            else {
                                                Text("\(matchup.homeTeam.abbrev) W")
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color(red: 26/255, green: 26/255, blue: 29/255))
                                                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                                        )
                                    }
                                }
                            }
                            Spacer()
                            
                            Text("\(game.homeTeam.commonName) Players")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            playerScrollView(viewModel.homePlayers)

                            
                            Spacer()
                            Text("\(game.awayTeam.commonName) Players")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            playerScrollView(viewModel.awayPlayers)

                        }
                        .padding()
                        
                        
                    } else {
                        Text("📭 No game data.")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 15/255, green: 15/255, blue: 16/255))
        
        .onAppear {
            viewModel.fetchGame(for: gameId)
            viewModel.fetchPlayers(for: home, isHome: true)
            viewModel.fetchPlayers(for: away, isHome: false)
            viewModel.fetchPreviousMatchup(for: home, opponent: away, season: "20242025")
        }
    }
}

func playerScrollView(_ players: [getPlayersResponse]) -> some View {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack() {
            ForEach(players, id: \.playerId) { player in
                VStack{
                    AsyncImage(url: URL(string: player.headshot)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 75, height: 75)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 100)
                    }
                    
                    Text(player.firstName)
                        .foregroundColor(.white)
                        .font(.caption2)
                    Text(player.lastName)
                        .foregroundColor(.white)
                        .font(.caption2)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(red: 26/255, green: 26/255, blue: 29/255))
                        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                )
            }
        }
    }
}

#Preview {
    PreliveView(gameId: "2025020001", home: "FLA", away: "CHI")
}

