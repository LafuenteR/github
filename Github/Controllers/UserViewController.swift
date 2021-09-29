//
//  UserViewController.swift
//  Github
//
//  Created by Ruel Lafuente on 9/25/21.
//

import UIKit
import CoreData

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    var users = [User]()
    var users:[Users]?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var UserTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserTableView.delegate = self
        UserTableView.dataSource = self
        UserTableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        
        let urlString = GlobalVariable.getUsersApi
        var thisUsers = [User]()
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                thisUsers = parseJson(json: data)
            }
        }
        
        for user in thisUsers {
            let urlString = "\(GlobalVariable.getUserProfile)\(user.login)"
            print(urlString)
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    let decoder = JSONDecoder()
                    if let userProfile = try? decoder.decode(Profile.self, from: data) {
                        print(userProfile)
                        if !userExist(id: userProfile.id) {
                            saveUser(profile: userProfile)
                        }
                    }
                }
            }
        }
        
        do {
            users = try context.fetch(Users.fetchRequest())
            UserTableView.reloadData()
        } catch {
            print("Error \(error)")
        }
    }
    
    func saveUser(profile: Profile) {
        let user = Users(context: self.context)
        user.id = Int64(profile.id)
        user.login = profile.login
        user.avatar_url = profile.avatar_url
        user.type = profile.type
        user.following = Int64(profile.following)
        user.followers = Int64(profile.followers)
        user.bio = profile.bio
        user.name = profile.name
        user.company = profile.company
        user.blog = profile.blog
        do {
            try self.context.save()
        } catch {
            print("Error \(error)")
        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let thisUser = users![indexPath.row]
        let cell = UserTableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.update(user: thisUser)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetails", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let viewController = segue.destination as! DetailViewController
            let selectedRow = sender as? Int
            let user = users![selectedRow!]
            viewController.user = user
        }
    }

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
}
