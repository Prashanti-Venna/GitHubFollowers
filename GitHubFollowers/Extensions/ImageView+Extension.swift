//
//  ImageView+Extension.swift
//  GitHubFollowers
//
//  Created by Prashanti Venna on 04/07/2024.
//

import UIKit
import Foundation

struct ImageHelper {
    
    static let cache = NetworkManager.shared.cache
    
    static func downloadImageView(from urlString: String, completion: @escaping (UIImage) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = self.cache.object(forKey: cacheKey) {
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }
        task.resume()
    }
}
