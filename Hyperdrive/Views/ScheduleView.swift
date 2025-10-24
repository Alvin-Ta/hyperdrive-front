//
//  ScheduleView.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-07-21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ScheduleView: View {
    @StateObject private var viewModel: ScheduleViewModel
    @State private var selectedDate = Date()
    let date: String
    
    init(date: String) {
        _viewModel = StateObject(wrappedValue: ScheduleViewModel())
        self.date = date

        let parsed = (try? Date(date, strategy: .iso8601.year().month().day())) ?? Date()
        _selectedDate = State(initialValue: parsed)
    }
    
    var body: some View {
        ScrollView {
            Text("Schedule")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            HorizontalWeekCalendar(selectedDate: $selectedDate, firstWeekday: 1).preferredColorScheme(.dark)

            VStack(spacing: 16) {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                } else if viewModel.games.isEmpty {
                    Text("📭 No games found.")
                }
                else{
                    ForEach(viewModel.games, id: \.gameId) { game in
                        NavigationLink(destination: prePostView(score: game.awayTeam.score, gameState: game.gameState, gameId: game.gameId, home: game.homeTeam.abbrev, away: game.awayTeam.abbrev)) {
                        HStack{
                            WebImage(url: URL(string: game.homeTeam.darkLogo))
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 45)
                            Spacer()
                            VStack{
                                Text(" \(game.homeTeam.abbrev) vs \(game.awayTeam.abbrev)")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .foregroundStyle(.white)
                                Image(systemName: "livephoto")
                                    .font(.system(size: 2))
//                                    .symbolEffect(.bounce.up.wholeSymbol, options: .nonRepeating, value: play)
                                if let awayScore = game.awayTeam.score, let homeScore = game.homeTeam.score {
                                    Text("\(homeScore) - \(awayScore)")
                                        .foregroundStyle(.white)
                                }
                                else {
                                    Text("\(formatGameTime(game.startTime))")
                                        .foregroundStyle(.white)
                                }
                            }
                            WebImage(url: URL(string: game.awayTeam.darkLogo))
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 45)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 26/255, green: 26/255, blue: 29/255)) // card color
                                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                        )
                    }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(.top, 50)
        }
        .padding()
        .background(Color(red: 15/255, green: 15/255, blue: 16/255))
        .navigationBarTitleDisplayMode(.inline)
        .task(id: selectedDate) {
            viewModel.fetchSchedule(for: selectedDate.formatted(.iso8601.year().month().day()))
        }
    }
}

func formatGameTime(_ isoTime: String) -> String {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime]

    guard let date = isoFormatter.date(from: isoTime) else {
        return "Invalid Date"
    }

    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "h:mm a"
    outputFormatter.timeZone = .current

    return outputFormatter.string(from: date)
}

@ViewBuilder
func prePostView(score: Int?, gameState: String, gameId: Int, home: String, away: String) -> some View {
    if gameState == "LIVE" {
        LiveView(gameId: String(gameId))
    }
    else if score != nil {   // or: if let _ = score
        PostgameView(gameId: "\(gameId)", home: home, away: away)
    } else {
        PreliveView(gameId: "\(gameId)", home: home, away: away)
    }
}

#Preview {
    NavigationStack {
        ScheduleView(date: Date().formatted(.iso8601.year().month().day()))
    }
}

