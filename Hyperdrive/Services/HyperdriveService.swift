//
//  HyperdriveService.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-07-09.
//

//router.get('/:game_id/boxscore', getBoxScore);
//router.get('/:id/games/:season/:gameType', getPlayerGameLog);
//router.get('/:team/now', getPreviousMatches);
//router.get('/:team/vs/:opponent/:season', getTeamVsTeamRecord);
//router.get('/:team/players', getPlayers);
//router.get('/:player/vs/:team', getPlayerMatchupHist);
//router.get('/now', getCurrentSchedule);
//router.get('/:date', getScheduleByDate);

import Foundation

class HyperdriveService {
    static let shared = HyperdriveService()
    private let baseURL = "https://hyperdrive-backend.onrender.com"
    
    init() {}
    
    func getBoxScore(gameId: String, completion: @escaping (Result<BoxScoreResponse, Error>) -> Void) {
        request (endpoint: "/game/\(gameId)/boxscore", completion: completion)
    }
    
    func getPlayByPlay(gameId: String, completion: @escaping (Result<PlayByPlayResponse, Error>) -> Void) {
        request (endpoint: "/game/\(gameId)/play-by-play", completion: completion)
    }
    
    func getPlayerGameLog(playerId: String, season: String, gameType: Int, completion: @escaping (Result<PlayerGameLogResponse, Error>) -> Void) {
        request (endpoint: "/player/\(playerId)/games/\(season)/\(gameType)", completion: completion)
    }
    
    func getPlayerInfo(playerId: String, completion: @escaping (Result<PlayerInfoResponse, Error>) -> Void) {
        request (endpoint: "/player/\(playerId)/info", completion: completion)
    }
    
    func getAllPlayers(completion: @escaping (Result<[AllPlayersResponse], Error>) -> Void) {
        request (endpoint: "/player/all", completion: completion)
    }
    
    func getPreviousMatches(team: String, completion: @escaping (Result<PreviousMatchesResponse, Error>) -> Void){
        request (endpoint: "/query/\(team)", completion: completion)
    }
    
    func getTeamVsTeamRecord(team: String, opponent: String, season: String, completion: @escaping (Result<TeamVsTeamRecordResponse, Error>) -> Void) {
        request (endpoint: "/query/\(team)/vs/\(opponent)/\(season)", completion: completion)
    }
    
    func getPlayers(team: String, completion: @escaping (Result<[getPlayersResponse], Error>) -> Void) {
        request(endpoint: "/query/\(team)/players", completion: completion)
    }
    
    func getPlayerMatchupHist(playerId: String, opponent: String, completion: @escaping (Result<[PlayerMatchupHistResponse], Error>) -> Void) {
        request(endpoint: "/query/\(playerId)/vs/\(opponent)", completion: completion)
    }
    
    func getScheduleByDate(date: String, completion: @escaping(Result<[ScheduleByDateResponse], Error>) -> Void) {
        request(endpoint: "/schedule/\(date)", completion: completion)
    }
    
    func getGameDetails(gameId: String, completion: @escaping (Result<gameDetailResponse, Error>) -> Void) {
        request (endpoint: "/detail/\(gameId)", completion: completion)
    }
    
    
    
    
    private func request<T: Decodable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            }
            
            //new
            catch let DecodingError.dataCorrupted(context) {
                print("🔴 Data corrupted:", context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("🔑 Key '\(key.stringValue)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context) {
                print("🧩 Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("🕳️ Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            }
            //new
            
            catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

//new
//catch let DecodingError.dataCorrupted(context) {
//    print("🔴 Data corrupted:", context)
//} catch let DecodingError.keyNotFound(key, context) {
//    print("🔑 Key '\(key.stringValue)' not found:", context.debugDescription)
//    print("codingPath:", context.codingPath)
//} catch let DecodingError.typeMismatch(type, context) {
//    print("🧩 Type '\(type)' mismatch:", context.debugDescription)
//    print("codingPath:", context.codingPath)
//} catch let DecodingError.valueNotFound(value, context) {
//    print("🕳️ Value '\(value)' not found:", context.debugDescription)
//    print("codingPath:", context.codingPath)
//}


//catch let decodingError as DecodingError {
//        // 🔎 Decode-specific error
//        print("❌ Decoding error:", decodingError)
//
//        switch decodingError {
//        case .typeMismatch(let type, let context):
//            print("🔎 Type mismatch for type \(type) at", context.codingPath)
//            print("Reason:", context.debugDescription)
//
//        case .valueNotFound(let type, let context):
//            print("🔎 Value not found for type \(type) at", context.codingPath)
//            print("Reason:", context.debugDescription)
//
//        case .keyNotFound(let key, let context):
//            print("🔎 Key '\(key.stringValue)' not found at", context.codingPath)
//            print("Reason:", context.debugDescription)
//
//        case .dataCorrupted(let context):
//            print("🔎 Data corrupted at", context.codingPath)
//            print("Reason:", context.debugDescription)
//
//        @unknown default:
//            print("⚠️ Unknown decoding error")
//        }
//
//        // Optional: dump raw JSON for inspection
//        if let jsonObject = try? JSONSerialization.jsonObject(with: data),
//           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
//           let jsonString = String(data: prettyData, encoding: .utf8) {
//            print("📦 Raw JSON:\n\(jsonString)")
//        }
//
//        completion(.failure(decodingError))
//
//    }

