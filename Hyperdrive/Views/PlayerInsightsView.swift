//
//  PlayerInsightsView.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-09-05.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlayerInsightsView: View {
    @StateObject var viewModel = InsightsViewModel()
    let playerId: Int
    private let cardBG   = Color(red: 26/255, green: 26/255, blue: 29/255)
    private let headerBG = Color(red: 36/255, green: 36/255, blue: 40/255)
    private let borderCol = Color(red: 58/255, green: 58/255, blue: 60/255)
    private let stripeBG  = Color(red: 32/255, green: 32/255, blue: 35/255)
    let visibleRowCount = 3
    let rowHeight: CGFloat = 48
    @State private var selectedTeam: String? = nil   // nil = placeholder
    let NHL_TEAM_CODES: [String] = [
      "ANA","BOS","BUF","CAR","CBJ","CGY","CHI","COL",
      "DAL","DET","EDM","FLA","LAK","MIN","MTL","NJD",
      "NSH","NYI","NYR","OTT","PHI","PIT","SEA","SJS",
      "STL","TBL","TOR","UTA","VAN","VGK","WPG","WSH"
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            VStack {
                HStack{
                    if viewModel.isLoading {
                        Text("🏒 Loading Player")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                    
                    else if let playerInfo = viewModel.playerInfo{
                        HStack(alignment: .center, spacing: 6) {
                            WebImage(url: URL(string: playerInfo.headshot))
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 110)
                            
                            VStack(alignment: .leading, spacing: 6){
                                Text("\(playerInfo.firstName) \(playerInfo.lastName)")
                                    .font(.title2)
                                    .italic()
                                Text(playerInfo.teamCommonName)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 40)
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
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
                    } else if let playerInfo = viewModel.playerInfo {
                        let curSeason = playerInfo.featuredStats.regularSeason.curSeason
                        let carStats = playerInfo.featuredStats.regularSeason.career
                        VStack(alignment: .leading, spacing: 10) {
                            Spacer()
                            Text("Matchup")
                                .foregroundColor(.white)
                                .bold()
                            
                            Picker("Opponent", selection: $selectedTeam) {
                                Text("Against").tag(nil as String?)

                                ForEach(NHL_TEAM_CODES, id: \.self) { code in
                                    Text(code).tag(Optional(code))
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(.white)
                            .onChange(of: selectedTeam) { _, newTeam in
                                guard let team = newTeam else { return }
                                viewModel.fetchMatchupHist(for: String(playerId), opponent: team)
                            }
                            if let _ = selectedTeam, !viewModel.isLoading {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 12).fill(cardBG)
                                    RoundedRectangle(cornerRadius: 12).stroke(borderCol, lineWidth: 1)
                                    ScrollView([.vertical, .horizontal]) {
                                        VStack(spacing: 0){
                                            HStack(spacing: 12) {
                                                Text("Points").frame(width: 62, alignment: .leading)
                                                    .font(.caption2).foregroundColor(.white)
                                                Text("Goals").frame(width: 62, alignment: .leading)
                                                    .font(.caption2).foregroundColor(.white)
                                                Text("Assists").frame(width: 75, alignment: .leading)
                                                    .font(.caption2).foregroundColor(.white)
                                                Text("Shots").frame(width: 70, alignment: .leading)
                                                    .font(.caption2).foregroundColor(.white)
                                                Text("pim").frame(width: 60, alignment: .leading)
                                                    .font(.caption2).foregroundColor(.white)
                                                Text("+/-").frame(width: 60, alignment: .leading)
                                                    .font(.caption2).foregroundColor(.white)
                                                Text("toi").frame(width: 64, alignment: .leading)
                                                    .font(.caption2).foregroundColor(.white)
                                            }
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundStyle(.secondary)
                                            .padding(.vertical, 10)
                                            
                                            ForEach(Array((viewModel.matchupHist).enumerated()), id: \.element.gameId) {i,g in
                                                HStack(spacing: 12) {
                                                    Text("\(g.points ?? 0)").frame(width: 62, alignment: .leading)
                                                        .font(.caption2).foregroundColor(.white)
                                                    Text("\(g.goals)").frame(width: 62, alignment: .leading)
                                                        .font(.caption2).foregroundColor(.white)
                                                    Text("\(g.assists)").frame(width: 75, alignment: .leading)
                                                        .font(.caption2).foregroundColor(.white)
                                                    Text("\(g.shots ?? 0)").frame(width: 70, alignment: .leading)
                                                        .font(.caption2).foregroundColor(.white)
                                                    Text("\(g.pim)").frame(width: 60, alignment: .leading)
                                                        .font(.caption2).foregroundColor(.white)
                                                    Text("\(g.plusMinus ?? 0)").frame(width: 60, alignment: .leading)
                                                        .font(.caption2).foregroundColor(.white)
                                                    Text("\(g.toi)").frame(width: 64, alignment: .leading)
                                                        .font(.caption2).foregroundColor(.white)
                                                }
                                                .padding(.vertical, 10)
                                                .background(i.isMultiple(of: 2) ? stripeBG : .clear)

                                                if i != (playerInfo.last5Games).count - 1 { Divider() }
                                            }
                                        }
                                        .padding(8)
                                    }
                                }
                                .frame(height: rowHeight * CGFloat(visibleRowCount))
                                .monospacedDigit()
                            }

                            Spacer()
                            Text("Last 5 Games")
                                .foregroundColor(.white)
                                .bold()
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 12).fill(cardBG)
                                RoundedRectangle(cornerRadius: 12).stroke(borderCol, lineWidth: 1)
                                
                                ScrollView([.vertical, .horizontal]) {
                                    VStack(spacing: 0) {
                                        HStack(spacing: 12) {
                                            Text("Date").frame(width: 62, alignment: .leading)
                                                .font(.caption2).foregroundColor(.white)
                                            Text("Opponent").frame(width: 64, alignment: .leading)
                                                .font(.caption2).foregroundColor(.white)

                                            headerRow()
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.9)
                                        }
                                        .padding(.vertical, 10)
                                        ForEach(Array((playerInfo.last5Games).enumerated()), id: \.element.gameId) {i,g in
                                            HStack(spacing: 12) {
                                                Text(formatDate(g.gameDate))
                                                    .frame(width: 62, alignment: .leading).font(.caption2).foregroundColor(.white)
                                                Text(g.opponentAbbrev)
                                                    .frame(width: 64, alignment: .leading).font(.caption2).foregroundColor(.white)

                                                Text("\(g.goals)").frame(width: 52, alignment: .leading).font(.caption2).foregroundColor(.white)
                                                Text("\(g.assists)").frame(width: 62, alignment: .leading).font(.caption2).foregroundColor(.white)
                                                Text("\(g.points)").frame(width: 62,   alignment: .leading).font(.caption2).foregroundColor(.white)
                                                Text("\(g.pim)").frame(width: 48,         alignment: .leading).font(.caption2).foregroundColor(.white)
                                                Text("\(g.shots)").frame(width: 40,       alignment: .leading).font(.caption2).foregroundColor(.white)
                                                Text(g.toi).frame(width: 64,              alignment: .leading).font(.caption2).foregroundColor(.white)
                                                Text("\(g.plusMinus)").frame(width: 64,  alignment: .leading).font(.caption2).foregroundColor(.white)
                                            }
                                            .padding(.vertical, 10)
                                            .background(i.isMultiple(of: 2) ? stripeBG : .clear)

                                            if i != (playerInfo.last5Games).count - 1 { Divider() }
                                        }
                                    }
                                    .padding(8)
                                }
                            }
                            .frame(height: rowHeight * CGFloat(visibleRowCount))
                            .monospacedDigit()
                            
                        Spacer()
                        Text("Season Stats")
                            .foregroundColor(.white)
                            .bold()
                            stats(seasonType: curSeason)
                        Spacer()
                            Text("Career Stats")
                                .foregroundColor(.white)
                                .bold()
                            stats(seasonType: carStats)
                        }
                        
                    }else {
                        Text("📭 No player data")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 15/255, green: 15/255, blue: 16/255))
        .onAppear {
            viewModel.fetchPlayerGameLog(for: String(playerId), season: "20232024", gameType: 2)
            viewModel.fetchPlayerInfo(for: String(playerId))
        }
    }
    @ViewBuilder
    private func headerRow() -> some View {
        HStack(spacing: 12) {
            Text("Goals").frame(width: 52, alignment: .leading)
                .font(.caption2).foregroundColor(.white)
            Text("Assists").frame(width: 62, alignment: .leading)
                .font(.caption2).foregroundColor(.white)
            Text("Points").frame(width: 62, alignment: .leading)
                .font(.caption2).foregroundColor(.white)
            Text("PIM").frame(width: 48, alignment: .leading)
                .font(.caption2).foregroundColor(.white)
            Text("SOG").frame(width: 40, alignment: .leading)
                .font(.caption2).foregroundColor(.white)
            Text("TOI").frame(width: 64, alignment: .leading)
                .font(.caption2).foregroundColor(.white)
            Text("+/-").frame(width: 64, alignment: .leading)
                .font(.caption2).foregroundColor(.white)
        }
        .font(.subheadline.weight(.semibold))
        .foregroundStyle(.secondary)
    }
    
    @ViewBuilder
    private func stats(seasonType: stats) -> some View {
        ZStack{
            RoundedRectangle(cornerRadius: 12).fill(cardBG)
            RoundedRectangle(cornerRadius: 12).stroke(borderCol, lineWidth: 1)
            ScrollView(.horizontal) {
                VStack(spacing: 0){
                    HStack(spacing: 12) {
                        Text("GP").frame(width: 52, alignment: .leading)
                            .font(.caption2).foregroundColor(.white)
                        Text("Goals").frame(width: 62, alignment: .leading)
                            .font(.caption2).foregroundColor(.white)
                        Text("Points").frame(width: 62, alignment: .leading)
                            .font(.caption2).foregroundColor(.white)
                        Text("Assists").frame(width: 75, alignment: .leading)
                            .font(.caption2).foregroundColor(.white)
                        Text("Shots").frame(width: 70, alignment: .leading)
                            .font(.caption2).foregroundColor(.white)
                        Text("pim").frame(width: 60, alignment: .leading)
                            .font(.caption2).foregroundColor(.white)
                        Text("+/-").frame(width: 60, alignment: .leading)
                            .font(.caption2).foregroundColor(.white)
                        Text("Shooting %").frame(width: 64, alignment: .leading)
                            .font(.caption2).foregroundColor(.white)
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 10)
                    
                    HStack(spacing: 12) {
                        Text("\(seasonType.gamesPlayed)").frame(width: 52, alignment: .leading)
                            .font(.caption2).foregroundColor(.white)
                        Text("\(seasonType.goals)").frame(width: 62, alignment: .leading)
                            .font(.caption2).foregroundColor(.white)
                        Text("\(seasonType.points)").frame(width: 62, alignment: .leading)
                            .font(.caption2).foregroundColor(.white)
                        Text("\(seasonType.assists)").frame(width: 75, alignment: .leading)
                            .font(.caption2).foregroundColor(.white)
                        Text("\(seasonType.shots)").frame(width: 70, alignment: .leading)
                            .font(.caption2).foregroundColor(.white)
                        Text("\(seasonType.pim)").frame(width: 60, alignment: .leading)
                            .font(.caption2).foregroundColor(.white)
                        Text("\(seasonType.plusMinus)").frame(width: 60, alignment: .leading)
                            .font(.caption2).foregroundColor(.white)
                        Text("\(seasonType.shootingPctg)").frame(width: 64, alignment: .leading)
                            .font(.caption2).foregroundColor(.white)
                    }
                    .padding(.vertical, 10)
                    .background(stripeBG)
                }
                .padding(8)
            }
        }
    }
    
    
}

#Preview {
    PlayerInsightsView(playerId: 8484144)
//    8484144
}
