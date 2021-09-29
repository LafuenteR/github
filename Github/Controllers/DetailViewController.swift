//
//  DetailViewController.swift
//  Github
//
//  Created by Ruel Lafuente on 9/26/21.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var user: Users?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = user?.name
        let urlString = "\(GlobalVariable.getUserProfile)\((user?.login)!)"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
//                users = parseJson(json: data)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
