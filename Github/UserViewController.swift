//
//  UserViewController.swift
//  Github
//
//  Created by Ruel Lafuente on 9/25/21.
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var users = [User]()
    @IBOutlet weak var UserTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserTableView.delegate = self
        UserTableView.dataSource = self
        UserTableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        let urlString = "https://api.github.com/users?since=0"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parseJson(json: data)
            }
        }
        
    }
    
    func parseJson(json: Data) {
        let decoder = JSONDecoder()
        if let jsonUsers = try? decoder.decode([User].self, from: json) {
            users = jsonUsers
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let thisUser = users[indexPath.row]
        let cell = UserTableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.update(user: thisUser)
        return cell
        
    }

}

struct User: Codable {
    var id: Int
    var login: String
    var avatar_url: String
    var type: String
}
