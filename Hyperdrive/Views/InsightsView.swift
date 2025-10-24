//
//  InsightsView.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-08-26.
//

import SwiftUI
import SDWebImageSwiftUI

struct InsightsView: View {
    @StateObject var viewModel = InsightsViewModel()
    @State private var query = ""

    // Show nothing until 2+ chars; prefix-only, case/diacritic-insensitive
    private var results: [AllPlayersResponse] {
        let raw = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard raw.count >= 2 else { return [] }

        let q = raw.folding(options: .diacriticInsensitive, locale: .current).lowercased()

        return viewModel.players.filter { p in
            let name = "\(p.firstName) \(p.lastName)"
                .folding(options: .diacriticInsensitive, locale: .current)
                .lowercased()
            return name.hasPrefix(q)
            ||
            p.firstName.range(of: q, options: [.anchored, .caseInsensitive, .diacriticInsensitive]) != nil
            || p.lastName .range(of: q, options: [.anchored, .caseInsensitive, .diacriticInsensitive]) != nil
        }
        .sorted { $0.lastName.localizedCaseInsensitiveCompare($1.lastName) == .orderedAscending }
    }

    var body: some View {
        ZStack {
            Color(red: 15/255, green: 15/255, blue: 16/255).ignoresSafeArea()

            VStack(spacing: 16) {
                if viewModel.isLoading {
                    ProgressView().tint(.white)
                } else if let err = viewModel.errorMessage {
                    Text("Error: \(err)").foregroundStyle(.secondary)
                } else if !results.isEmpty {
                    List(results, id: \.id) { p in
                        NavigationLink{
                            PlayerInsightsView(playerId: p.id)
                        } label: {
                            HStack {
                                WebImage(url: URL(string: p.teamLogo))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 20)
                                Text("\(p.firstName) \(p.lastName)")
                            }
                        }
                        .foregroundStyle(.white)
                        .listRowBackground(Color(red: 26/255, green: 26/255, blue: 29/255))
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                } else if query.count >= 2 {
                    Text("No matches").foregroundStyle(.secondary)
                }
                else {
                    Text("add bdays n streaks").foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .searchable(text: $query,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search players")
                    .foregroundColor(.white)
        .task { viewModel.fetchPlayers() }
    }
}



private extension String {
    func hasPrefixInsensitive(_ prefix: String) -> Bool {
        range(of: prefix, options: [.anchored, .caseInsensitive, .diacriticInsensitive]) != nil
    }
}

#Preview {
    NavigationStack { InsightsView() }
}
