//
//  liveView.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-09-17.
//

import SwiftUI
import SDWebImageSwiftUI

struct LiveView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var viewModel = LiveViewModel()

    let gameId: String

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                if let game = viewModel.PlayByPlay {
                    Spacer()
                    VStack {
                        WebImage(url: URL(string: game.awayTeam.darkLogo))
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 50)
                        Text("\(game.awayTeam.score)")
                            .font(.title3)
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
                    VStack {
                        WebImage(url: URL(string: game.homeTeam.darkLogo))
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 50)
                        Text("\(game.homeTeam.score)")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
            }
            .padding()
            .background(Color(red: 26/255, green: 26/255, blue: 29/255))
            
            HStack {
                Spacer()
//                if viewModel.isFinished {
                    let top = viewModel.plays.first
                    if (top?.timeRemaining ?? "") == "00:00" {
                        Text("\(top?.typeDescKey.replacingOccurrences(of: "-", with: " ") ?? "")")
                            .foregroundColor(.white)
                    }
                    else if (top?.typeDescKey == "stoppage") {
                        Text("Stoppage (\(top?.details?.reason?.replacingOccurrences(of: "-", with: " ") ?? "")")
                            .foregroundColor(.white)
                    }
                    else {
                        Text("\(top?.timeRemaining ?? "")")
                            .foregroundColor(.white)
                    }
//                }
                Spacer()
            }
            .padding(7)
            .background(.black)

            // Body
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    if let error = viewModel.errorMessage {
                        Text("❌ \(error)").foregroundStyle(.red)
                    }

                    ForEach(viewModel.plays, id: \.eventId) { play in
                        EventRow(play: play, viewModel: viewModel)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    if viewModel.plays.isEmpty && viewModel.errorMessage == nil {
                        // First-load empty state (no spinner after that)
                        Text("Waiting for events…")
                            .foregroundStyle(.secondary)
                            .padding(.top, 16)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            .background(Color(red: 15/255, green: 15/255, blue: 16/255))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 15/255, green: 15/255, blue: 16/255))

        .task { viewModel.startPolling(gameId: gameId);
            viewModel.fetchPlayByPlay(for: gameId)}// start when view appears
        .onDisappear { viewModel.stopPolling() }               // stop when leaving
        .onChange(of: scenePhase) { _, phase in                // pause in background
            if phase == .background { viewModel.stopPolling() }
            else if phase == .active { viewModel.startPolling(gameId: gameId) }
        }
    }
}

// Simple row; customize as you like
private struct EventRow: View {
    let play: Plays
    @ObservedObject var viewModel: LiveViewModel
    
    var body: some View {
        if play.typeDescKey != "period-start" && play.typeDescKey != "period-end" && play.typeDescKey != "game-end" && play.typeDescKey != "stoppage"{
            VStack(spacing: 12) {
              HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 10) {
                  Text(viewModel.title(for: play))
                        .font(.subheadline).bold()
                    .foregroundColor(viewModel.titleColor(for: play))
                  viewModel.nameLines(for: play)
                }

                Spacer()

                  Text("P\(play.periodDescriptor.number): \(play.timeRemaining)")
                  .font(.callout)
                  .foregroundColor(.white)
              }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.04))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5)
            )
        }
    }
}

#Preview {
    LiveView(gameId: "2025010030")
}

