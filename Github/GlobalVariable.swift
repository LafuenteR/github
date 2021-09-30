//
//  GlobalVariable.swift
//  Github
//
//  Created by Ruel Lafuente on 9/27/21.
//

import Foundation

struct GlobalVariable {
    static var getUsersApi = "https://api.github.com/users?since=0"
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
    var type: String
    var following: Int
    var followers: Int
    var bio: String?
    var name: String?
    var company: String?
    var blog: String?
    var notes: String?
}

