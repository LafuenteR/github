//
//  GlobalVariable.swift
//  Github
//
//  Created by Ruel Lafuente on 9/27/21.
//

import Foundation
import CoreData

struct GlobalVariable {
    static var getUsersApi = "https://api.github.com/users?since="
    static var getUserProfile = "https://api.github.com/users/"
}

struct User: Codable {
    var id: Int
    var login: String
    var avatar_url: String
}

struct Profile: Codable {
    var id: Int
    var login: String
    var avatar_url: String
    var following: Int
    var followers: Int
    var bio: String?
    var name: String?
    var company: String?
    var blog: String?
    var notes: String?
    var isSeen: Bool?
}

struct Translation {
    static var followers = "followers:"
    static var following = "following:"
    static var company = "company:"
    static var na = "N/A"
    static var blog = "blog:"
    static var name = "name:"
    static var empty = ""
}

