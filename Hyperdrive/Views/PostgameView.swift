//
//  PostgameView.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-08-13.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostgameView: View {
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
                                .opacity(loserOpacity(game: game, teamId: game.awayTeam.id))
                        }
                        
                        Spacer()
                        
                        VStack (spacing: 8){
                            HStack(spacing: 26){
                            Text("\(game.awayTeam.score ?? 0)")
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                                .opacity(loserOpacity(game: game, teamId: game.awayTeam.id))
                        
                
                            Text("\(game.homeTeam.score ?? 0)")
                                .font(.title)
                                .bold()
                                .opacity(loserOpacity(game: game, teamId: game.homeTeam.id))
                                .foregroundColor(.white)
                            }
                            .padding(.top, 28)

                            Text(game.gameState)
                                .font(.subheadline)
                                .bold()
                        }
                        Spacer()
                        VStack(spacing: 15) {
                            WebImage(url: URL(string: game.homeTeam.darkLogo))
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 70)
                                .opacity(loserOpacity(game: game, teamId: game.homeTeam.id))
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

            
            ScrollView {
                VStack(spacing: 12) {
                    if viewModel.isLoading {
                        ProgressView("Loading game...")
                    } else if let error = viewModel.errorMessage {
                        Text("❌ Error: \(error)")
                            .foregroundColor(.red)
                    } else if let game = viewModel.games?.gameDetails {
                        
                        
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Period Scoring")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .bold()
                            
                            HStack() {
                                VStack(spacing: 9) {
                                    Spacer()
                                    WebImage(url: URL(string: game.homeTeam.darkLogo))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: 23)

                                    WebImage(url: URL(string: game.awayTeam.darkLogo))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: 23)
                                }
                                    ForEach(game.summary.scoring, id: \.periodDescriptor.number) { period in
                                        
                                        if period.periodDescriptor.number > 3 {
                                            VStack(spacing: 12){
                                                Text("OT")
                                                    .font(.title2)
                                                    .foregroundColor(.white)
                                                periodScoring(period: period, summary: game.summary)
                                            }
                                        }
                                        else if period.periodDescriptor.number > 4 {
                                            VStack(spacing: 12){
                                                Text("2OT")
                                                    .font(.title2)
                                                    .foregroundColor(.white)
                                                periodScoring(period: period, summary: game.summary)
                                            }
                                        }
                                        else {
                                            VStack(spacing: 12) {
                                                Text("\(period.periodDescriptor.number)")
                                                    .foregroundColor(.white)
                                                    .font(.title2)
                                                periodScoring(period: period, summary: game.summary)
                                                
                                            }
                                        }
                                        Divider()
                                        .frame(width: 1)                       // make it vertical
                                        .frame(maxHeight: .infinity)           // stretch
                                        .background(Color.white.opacity(0.15)) // visible in dark mode
                                        .padding(.vertical, 4)
                                    }
                                
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }



                            Spacer()
                            
                            Text("Highlight Plays")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .bold()
                            
                            ForEach(game.summary.scoring, id: \.periodDescriptor.number) { period in
                                
                                if period.periodDescriptor.number > 3 {
                                    Divider()
                                    .background(Color.white.opacity(0.2))
                                    Text("OT")
                                        .foregroundColor(.gray)
                                    ForEach(period.goals, id: \.playerId) { goal in
                                        highlightPlays(goal: goal)
                                    }
                                }
                                else {
                                    Divider()
                                    .background(Color.white.opacity(0.2))
                                    Text("Period \(period.periodDescriptor.number)")
                                        .foregroundColor(.gray)
                                    ForEach(period.goals, id: \.pptReplayUrl) { goal in
                                        highlightPlays(goal: goal)
                                    }
                                }
                            }
                            
                            Spacer()
                            Text("Top Performers")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .bold()
                            
                            if let tp = viewModel.boxscore?.topPerformers {
                                Text("\(tp.homeTeamName)")
                                    .foregroundColor(.gray)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Divider()
                                    .background(Color.white.opacity(0.2))
                                teamPerformers(team: tp.homeTeam)
                                Divider()
                                .background(Color.white.opacity(0.2))
                                
                                Spacer()
                                
                                Text("\(tp.awayTeamName)")
                                    .foregroundColor(.gray)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Divider()
                                .background(Color.white.opacity(0.2))
                                teamPerformers(team: tp.awayTeam)
                            }
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
            viewModel.fetchBoxscore(for: gameId)
        }
    }
}

func loserOpacity(game: gameDetails, teamId: Int) -> Double {
    guard let home = game.homeTeam.score, let away = game.awayTeam.score else { return 1.0 }
    
    let homeLost = home < away
    let awayLost = away < home
    if game.homeTeam.id == teamId { return homeLost ? 0.4 : 1.0 }
    if game.awayTeam.id == teamId { return awayLost ? 0.4 : 1.0 }
    return 1.0
}

@ViewBuilder
func periodScoring(period: ScoringPeriod, summary: gameSummary) -> some View {
    let sum = summary.scoring
    if period.periodDescriptor.number == 1 {
        VStack(spacing: 14){
                Text("\(period.goals.last?.homeScore ?? 0)")
                    .foregroundColor(.white)
                
                Text("\(period.goals.last?.awayScore ?? 0)")
                    .foregroundColor(.white)
        }
    }

    else {
        VStack(spacing: 14){
            Text("\((period.goals.last?.homeScore ?? 0) - (sum[period.periodDescriptor.number - 2].goals.last?.homeScore ?? 0))")
                .foregroundColor(.white)
                
            Text("\((period.goals.last?.awayScore ?? 0) - (sum[period.periodDescriptor.number - 2].goals.last?.awayScore ?? 0))")
                .foregroundColor(.white)
        }
    }
}

func highlightPlays(goal: Goal) -> some View {
    HStack(alignment: .firstTextBaseline, spacing: 12){
        Text("\(subtractTimes(start: goal.timeInPeriod))")
            .foregroundColor(.white)
            .monospacedDigit()
            .font(.subheadline)
            .frame(width: 56, alignment: .leading)

        VStack(alignment: .leading, spacing: 2) {
            Text("\(goal.name.firstName) \(goal.name.lastName)")
                .font(.subheadline)
                .lineLimit(1)
                .truncationMode(.tail)
                .layoutPriority(1)
                .foregroundColor(.white)
            
            HStack(spacing: 6){
                Text("Ast:")
                    .font(.caption2)
                    .lineLimit(1)
                    .foregroundStyle(.secondary)
                    .foregroundColor(.white)
                
                
                Text(assistsLine(assists: goal.assists))
                    .font(.caption2)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .minimumScaleFactor(0.85)
                    .layoutPriority(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        if goal.awayScore != goal.homeScore{
            Text("\(goal.leadingTeamAbbrev ?? "") leads \(goal.awayScore)-\(goal.homeScore)")
                .font(.caption2)
                .foregroundColor(.white)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(width: 130, alignment: .trailing)
        }
        else {
            Text("\(goal.teamAbbrev) ties \(goal.awayScore)-\(goal.homeScore)")
                .font(.caption2)
                .foregroundColor(.white)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(width: 130, alignment: .trailing)
        }
    }
}

func teamPerformers(team: [Skater]) -> some View {
    ForEach(team, id: \.playerID) { player in
        
        VStack(spacing: 12){
            Text("\(player.name.nameDefault)")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        
            HStack(spacing: 2) {
                Text("Goals: \(player.goals)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("Ast: \(player.assists)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("Pts: \(player.points)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("TOI: \(player.toi)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                }
        }
    }
}

func subtractTimes(start: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    formatter.timeZone = TimeZone(secondsFromGMT: 0) // keep it in 24h
    
    guard let startDate = formatter.date(from: start),
          let endDate = formatter.date(from: "20:00") else {
        return ""
    }
    
    // Compute difference
    let diff = endDate.timeIntervalSince(startDate)
    let hours = Int(diff) / 3600
    let minutes = (Int(diff) % 3600) / 60
    
    // Format as HH:mm
    return String(format: "%02d:%02d", hours, minutes)
}

func shortName(first: String, last: String) -> String {
    let initials = first
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .split(separator: "-")
        .map { $0.prefix(1).uppercased() + "." }
        .joined(separator: "\u{2011}")

    // nice casing + prevent hyphen break in last names too
    let capLast = last.prefix(1).uppercased() + last.dropFirst().lowercased()
    let safeLast = capLast.replacingOccurrences(of: "-", with: "\u{2011}")

    return "\(initials)\(safeLast)"
}

func assistsLine(assists: [Assist]) -> String {
    assists.map { shortName(first: $0.name.firstName, last: $0.name.lastName) }
           .joined(separator: ", ")
}


#Preview {
    PostgameView(gameId: "2024010010", home: "TOR", away: "OTT")
}

