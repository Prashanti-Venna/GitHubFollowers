//
//  PersistanceManager.swift
//  GitHubFollowers
//
//  Created by Prashanti Venna on 26/07/2024.
//

import Foundation

enum PersistanceActionType {
    case add, remove
}

enum PersistanceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favourites = "favourites"
    }
    
    static func retrieveFavourites(completion: @escaping(Result<[Follower], GHError>) -> Void) {
        guard let favouritesData = defaults.object(forKey: Keys.favourites) as? Data else {
            completion(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let favourites = try decoder.decode([Follower].self, from: favouritesData)
            completion(.success(favourites))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }
    
    static func saveFavourites(favourites:[Follower]) -> GHError? {
        do {
            let encoder = JSONEncoder()
            let favourites = try encoder.encode(favourites)
            defaults.setValue(favourites, forKey: Keys.favourites)
        } catch {
            return GHError.unableToFavorite
        }
        return nil
    }
    
    static func updateFavourite(favourite: Follower, actionType: PersistanceActionType, completion: @escaping (GHError?) -> Void) {
        retrieveFavourites { result in
            switch result {
            case .success(let followers):
                var allFavourites = followers
                switch actionType {
                case .add :
                    guard !allFavourites.contains(favourite) else {
                        completion(GHError.alreadyInFavourites)
                        return
                    }
                    allFavourites.append(favourite)
                    break
                case .remove:
                    allFavourites.removeAll {
                        $0.login == favourite.login
                    }
                }
               completion(saveFavourites(favourites: allFavourites))
            case .failure(let error):
                completion(error)
            }
        }
    }
}

