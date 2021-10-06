//
//  GithubTests.swift
//  GithubTests
//
//  Created by Ruel Lafuente on 10/2/21.
//

import XCTest
@testable import Github

class GithubTests: XCTestCase {
    
    func test_is_divisible_by_four() {
        let number = 4
        let isnumberDivisbleByFour = number.divisibleByFour()
        XCTAssertTrue(isnumberDivisbleByFour)
    }
    
    func test_create_user() {
        let fetchUsers = UserManager.shared.fetchUsers()
        let pagination = fetchUsers.count > 0 ? Int(fetchUsers.last!.id) : 0
        let urlString = "\(GlobalVariable.getUsersApi)\(pagination)"
        var thisUsers = [User]()
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                thisUsers = UserManager.shared.parseJson(json: data)
            }
        }
        for user in thisUsers {
            UserManager.shared.decodeUser(user: user)
            if user.id == thisUsers.last!.id {
                let lastUserID = Int(UserManager.shared.fetchUsers().last!.id)
                XCTAssertEqual(lastUserID, thisUsers.last!.id)
            }
        }
    }
    
    func test_search_user() {
        let searchText = "mojombo"
        let users = UserManager.shared.searchUsers(searchText: "searchText")
        if users.count > 0 {
            XCTAssertEqual(users.first?.login, searchText)
        }
    }
    
    func test_users_count() {
        let fetchUsers = UserManager.shared.fetchUsers()
        if fetchUsers.count > 0 {
            XCTAssertTrue(fetchUsers.count > 20)
        }
    }
    
    func test_update_user_seen() {
        let fetchUsers = UserManager.shared.fetchUsers()
        if fetchUsers.count > 0 {
            let user = fetchUsers.last
            let lastUser = Profile(id: Int(user!.id), login: user!.login!, avatar_url: user!.avatar_url!, following: Int(user!.following), followers: Int(user!.followers), bio: user!.bio, name: user!.name, company: user!.company, blog: user!.blog, notes: user!.notes, isSeen: user?.isSeen)
            UserManager.shared.updateUser(isUpdateNotes: false, notes: Translation.empty, user: lastUser)
            XCTAssertTrue(UserManager.shared.fetchUsers().last!.isSeen)
        }
    }
    
    

}
