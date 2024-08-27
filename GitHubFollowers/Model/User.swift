//
//  User.swift
//  GitHubFollowers
//
//  Created by Prashanti Venna on 03/07/2024.
//

import Foundation

struct User: Codable {
    var login: String?
    var avatarUrl: String?
    var htmlUrl: String?
    var name: String?
    var location: String?
    var publicRepos: Int?
    var publicGists: Int?
    var followers: Int?
    var following: Int?
    var createdAt: String?
    var bio: String?
}

