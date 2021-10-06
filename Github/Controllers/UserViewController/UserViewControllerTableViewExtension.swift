//
//  UserViewControllerTableViewExtension.swift
//  Github
//
//  Created by Ruel Lafuente on 10/5/21.
//

import Foundation
import UIKit


extension UserViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let thisUser = users![indexPath.row]
        let cell = UserTableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        let thisIndex = indexPath.row + 1
        cell.update(user: thisUser, index: thisIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetails", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
