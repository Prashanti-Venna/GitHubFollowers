//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Prashanti Venna on 03/07/2024.
//

import UIKit

enum GHError: String, Error {
    case invalidUrl = "Invalid Url"
    case invalidResponse = "Invalid Response"
    case networkIssue = "Network Issue"
    case invalidData = "Invalid Data"
    case generic = "Please try again later"
    case unableToFavorite = "Unable to favourite. Please try again"
    case alreadyInFavourites = "Already this user is in your favourite list"
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseUrl = "https://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>() 
    
    private init() {
        
    }
    
    func getFollowers(username: String, page: Int, completionHandler: @escaping (Result<[Follower], GHError>) -> Void) {
        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completionHandler(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completionHandler(.failure(.generic))
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completionHandler(.success(followers))
            } catch {
                    completionHandler(.failure(.generic))
            }
        }
        task.resume()
    }
    
    
    func getUserInfo(username: String, completionHandler: @escaping (Result<User, GHError>) -> Void) {
        let endpoint = baseUrl + username
        
        guard let url = URL(string: endpoint) else {
            completionHandler(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completionHandler(.failure(.generic))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let userInfo = try decoder.decode(User.self, from: data)
                completionHandler(.success(userInfo))
            } catch {
                completionHandler(.failure(.generic))
            }
            
        }
        task.resume()
    }
}
