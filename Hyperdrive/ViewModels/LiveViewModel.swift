//
//  LiveViewModel.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-09-17.
//

import Foundation
import Combine
import SwiftUI

class LiveViewModel: ObservableObject {
    @Published var PlayByPlay: PlayByPlayResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published private(set) var plays: [Plays] = []
    @Published private(set) var isFinished = false
    
    private var rosterById: [Int: (first: String, last: String, headshot: URL?)] = [:]
    private var timerCancellable: AnyCancellable?
    private var inFlight = false
    private var knownIds = Set<Int>()          // O(1) dedupe
    private var currentGameId = ""             // set on start

    // ---- Public API ----
    func startPolling(gameId: String) {
        stopPolling()
        currentGameId = gameId
        fetchOnce(animated: false)             // first paint: no animation
        timerCancellable = Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.fetchOnce(animated: true) }
    }

    func stopPolling() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    // ---- Core fetch ----
    private func fetchOnce(animated: Bool) {
        guard !inFlight, !isFinished, !currentGameId.isEmpty else { return }
        inFlight = true
        errorMessage = nil

        HyperdriveService.shared.getPlayByPlay(gameId: currentGameId) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.inFlight = false

                switch result {
                case .success(let resp):
                    // Stop when final or explicit game-end event appears
                    if resp.gameState.uppercased() == "FINAL"
                        || resp.plays.last?.typeDescKey == "game-end" {
                        self.ingest(resp.plays, animated: false)
                        self.isFinished = true
                        self.stopPolling()
                        return
                    }
                    self.ingest(resp.plays, animated: animated)

                case .failure(let err):
                    self.errorMessage = err.localizedDescription
                }
            }
        }
    }

    // Server list is oldest -> newest. We prepend only unseen items.
    private func ingest(_ serverPlaysOldestFirst: [Plays], animated: Bool) {
        // Fast no-op: if we already have the latest id, nothing to do
        if let lastServer = serverPlaysOldestFirst.last?.eventId,
           let lastLocalTop = plays.first?.eventId,
           lastServer == lastLocalTop || knownIds.contains(lastServer) {
            return
        }

        let delta = serverPlaysOldestFirst.filter { !knownIds.contains($0.eventId) }
        guard !delta.isEmpty else { return }

        delta.forEach { knownIds.insert($0.eventId) }
        let apply = { self.plays.insert(contentsOf: delta.reversed(), at: 0) }
        animated ? withAnimation(.snappy, apply) : apply()
    }

    deinit { stopPolling() }  // extra safety
    
    func fetchPlayByPlay(for gameId: String) {
        isLoading = true
        errorMessage = nil

        HyperdriveService.shared.getPlayByPlay(gameId: gameId) { [weak self] result in
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let pbp):
//                    print(pbp)
                    self.PlayByPlay = pbp
//                    print(pbp.rosterSpots)
                    if self.rosterById.isEmpty {
                        let spots = pbp.rosterSpots
                        self.rosterById = Dictionary(uniqueKeysWithValues: spots.map{
                            ($0.playerId, ($0.firstName, $0.lastName, URL(string: $0.headshot)))
                        })
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
        }
    }
    
    func playerInfo(for id: Int?) -> (first: String, last: String, headshot: URL?)? {
//        print(rosterById)
        guard let id else { return nil }
        return rosterById[id]
    }
    
    func title (for play: Plays) -> String {
        switch play.kind {
        case .goal:
            return "🚨 \((play.details?.shotType ?? "").capitalized) shot Goal 🚨" 
        case .shotOnGoal:
            return "\((play.details?.shotType ?? "").capitalized) shot on goal"
        case .missedShot:
            return "Missed shot, \(play.details?.reason?.replacingOccurrences(of: "-", with: " ") ?? "")"
        case .blockedShot:
            return "Blocked Shot"
        case .faceoff:
            return "Faceoff"
        case .giveaway:
            return "Giveaway"
        case .hit:
            return "Hit"
        default:
            return play.typeDescKey.replacingOccurrences(of: "-", with: "")
        }
    }
    
    func titleColor(for play: Plays) -> Color {
        switch play.kind{
        case .goal: return .blue
        default: return.white
        }
    }
    
    private func name(_ id: Int?, pre: Bool) -> String {
        if pre {
            playerInfo(for: id).map { "\($0.first.prefix(1)).\($0.last)" } ?? "-"
        }
        else {
            playerInfo(for: id).map { "\($0.first) \($0.last)" } ?? "-"
        }
    }
    
    @ViewBuilder
    func nameLines(for play: Plays) -> some View {
        switch play.kind {
        case .goal:
            HStack{
                AsyncImage(url: playerInfo(for: play.details?.scoringPlayerId)?.headshot) { image in
                    image.resizable().frame(width: 65, height: 65)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
                VStack (alignment: .leading){
                    Text(name(play.details?.scoringPlayerId, pre: false))
                        .font(.subheadline)
                        .foregroundColor(.white).bold()
                    if play.details?.assist1PlayerId != nil{
                        Text(name(play.details?.assist1PlayerId, pre: true))
                            .foregroundColor(.white).font(.caption2).opacity(0.5).bold()
                    }
                    if play.details?.assist2PlayerId != nil{
                        Text(name(play.details?.scoringPlayerId, pre: true))
                            .foregroundColor(.white).font(.caption2).opacity(0.5).bold()
                    }
                    Spacer()
                }
            }
            
        case .shotOnGoal, .missedShot:
            HStack {
                AsyncImage(url: playerInfo(for: play.details?.shootingPlayerId)?.headshot) { image in
                    image.resizable().frame(width: 65, height: 65)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }

                VStack {
                    Text("\(name(play.details?.shootingPlayerId, pre: false))").font(.subheadline).foregroundColor(.white).bold()
                    Spacer()
                }
            }
            
        case .blockedShot:
            HStack {
                AsyncImage(url: playerInfo(for: play.details?.blockingPlayerId)?.headshot) { image in
                    image.resizable().frame(width: 65, height: 65)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }

                VStack (alignment: .leading){
                    Text("\(name(play.details?.blockingPlayerId, pre: false))").font(.subheadline).foregroundColor(.white).bold()
                    Text("Shooter: \(name(play.details?.shootingPlayerId, pre: true))").foregroundColor(.white).font(.caption2).opacity(0.5).bold()
                    Spacer()
                }
            }
            
        case .faceoff:
            HStack(alignment: .center, spacing: 12) {
                Spacer()
                AsyncImage(url: playerInfo(for: play.details?.winningPlayerId)?.headshot) { image in
                    image.resizable().frame(width: 40, height: 40)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
                VStack {
                    Text("\(name(play.details?.winningPlayerId, pre: true))").foregroundColor(.white).font(.caption2).bold()        .lineLimit(1).minimumScaleFactor(0.7)
                        .frame(width: 50, alignment: .trailing)
                }
                
                Text("VS.").foregroundColor(.white).font(.caption2).bold()
                
                VStack {
                    Text("\(name(play.details?.losingPlayerId, pre: true)) ").foregroundColor(.white).font(.caption2).opacity(0.5).bold()
                        .lineLimit(1).minimumScaleFactor(0.7)
                        .frame(width: 50, alignment: .trailing)
                }
                AsyncImage(url: playerInfo(for: play.details?.losingPlayerId)?.headshot) { image in
                    image.resizable().frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .opacity(0.5)
                } placeholder: {
                    ProgressView()
                }
            }
            .frame(maxWidth: .infinity)

        case .hit:
            HStack {
                AsyncImage(url: playerInfo(for: play.details?.hittingPlayerId)?.headshot) { image in
                    image.resizable().frame(width: 65, height: 65)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }

                VStack (alignment: .leading){
                    Text("\(name(play.details?.hittingPlayerId, pre: false))").font(.subheadline).foregroundColor(.white).bold()
                    Text("On: \(name(play.details?.hitteePlayerId, pre: true))").foregroundColor(.white).font(.caption2).opacity(0.5).bold()
                    Spacer()
                }
            }

        case .giveaway:
            HStack {
                AsyncImage(url: playerInfo(for: play.details?.playerId)?.headshot) { image in
                    image.resizable().frame(width: 65, height: 65)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }

                VStack {
                    Text("\(name(play.details?.playerId, pre: false))").font(.subheadline).foregroundColor(.white).bold()
                    Spacer()
                }
            }

        default:
            Text ("idk")
        }
    }
}
