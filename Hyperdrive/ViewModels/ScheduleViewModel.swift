//
//  ScheduleViewModel.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-07-17.
//

import Foundation
import Combine

class ScheduleViewModel: ObservableObject {
    @Published var games: [ScheduleByDateResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchSchedule(for date: String) {
//        print("Reaches fetch")
        isLoading = true
        errorMessage = nil

        HyperdriveService.shared.getScheduleByDate(date: date) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let games):
//                    print(games)
                    self?.games = games
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}




