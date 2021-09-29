//
//  UIViewControllerExtension.swift
//  Github
//
//  Created by Ruel Lafuente on 9/26/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    func parseJson(json: Data) -> [User] {
        let decoder = JSONDecoder()
        var users = [User]()
        if let jsonUsers = try? decoder.decode([User].self, from: json) {
            users = jsonUsers
            return users
        }
        return users
    }
}
