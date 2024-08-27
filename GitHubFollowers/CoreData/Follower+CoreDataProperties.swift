//
//  Follower+CoreDataProperties.swift
//  GitHubFollowers
//
//  Created by Prashanti Venna on 29/07/2024.
//
//

import Foundation
import CoreData


extension Follower {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Follower> {
        return NSFetchRequest<Follower>(entityName: "Follower")
    }

    @NSManaged public var login: String?
    @NSManaged public var avatarUrl: String?

}

extension Follower : Identifiable {

}
