//
//  UserManager.swift
//  Github
//
//  Created by Ruel Lafuente on 10/6/21.
//

import Foundation
import CoreData

class UserManager {
    
    static let shared = UserManager()
    
    let context = CoreDataStack.shared.mainContext
    
    func createUser(profile: Profile) {
        let user = Users(context: self.context)
        user.id = Int64(profile.id)
        user.login = profile.login
        user.avatar_url = profile.avatar_url
        user.following = Int64(profile.following)
        user.followers = Int64(profile.followers)
        user.bio = profile.bio
        user.name = profile.name
        user.company = profile.company
        user.blog = profile.blog
        user.isSeen = false
        do {
            try self.context.save()
        } catch {
            print("Error \(error)")
        }
    }
    
    func fetchUsers() -> [Users] {
        var users:[Users]?
        do {
            users = try context.fetch(Users.fetchRequest())
        } catch {
            print("Error \(error)")
        }
        return users!
    }
    
    func searchUsers(searchText: String) -> [Users] {
        var users:[Users]?
        do {
            let request: NSFetchRequest<Users> = Users.fetchRequest()
            request.predicate = NSPredicate(format: "(login CONTAINS[C] %@) OR (notes CONTAINS[C] %@)", searchText, searchText)
            users = try self.context.fetch(request)
        } catch {
            print("Error \(error)")
        }
        return users!
    }
    
    func userExist(id: Int) -> Bool {
        do {
            let request: NSFetchRequest<Users> = Users.fetchRequest()
            request.predicate = NSPredicate(format: "id == \(id)")
            let user = try self.context.fetch(request)
            if user.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            print("Error \(error)")
        }
        return false
    }
    
    func updateUser(isUpdateNotes: Bool, notes: String, user: Profile) {
        do {
            let request: NSFetchRequest<Users> = Users.fetchRequest()
            request.predicate = NSPredicate(format: "id == \(user.id)")
            let user = try self.context.fetch(request)
            if isUpdateNotes {
                user.first!.notes = notes
            } else {
                user.first!.isSeen = true
            }
            do {
                try self.context.save()
            } catch {
                
            }
        } catch {
            print("Error \(error)")
        }
    }
    
    func parseJson(json: Data) -> [User] {
        let decoder = JSONDecoder()
        var users = [User]()
        if let jsonUsers = try? decoder.decode([User].self, from: json) {
            users = jsonUsers
            return users
        }
        return users
    }
    
    func decodeUser(user: User) {
        let urlString = "\(GlobalVariable.getUserProfile)\(user.login)"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                let decoder = JSONDecoder()
                if let userProfile = try? decoder.decode(Profile.self, from: data) {
                    print(userProfile)
                    if !UserManager.shared.userExist(id: userProfile.id) {
                        UserManager.shared.createUser(profile: userProfile)
                    }
                }
            }
        }
    }
}
