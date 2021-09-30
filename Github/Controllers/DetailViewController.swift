//
//  DetailViewController.swift
//  Github
//
//  Created by Ruel Lafuente on 9/26/21.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var userInfoTextView: UITextView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveBtnUI: UIButton!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var user: Profile!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadController()
    }
    
    func loadController() {
        UIupdate()
        followersLabel.text = "followers: \(user.followers)"
        followingLabel.text = "following: \(user.following)"
        userInfoTextView.text = "name: \(user.name ?? "")\ncompany: \(user.company ?? "N/A") \nblog: \((user.blog ?? "N/A"))"
        notesTextView.text = user.notes
    }
    
    func UIupdate() {
        self.title = user.name
        userInfoTextView.layer.borderColor = UIColor.black.cgColor
        userInfoTextView.layer.borderWidth = 1.0
        notesTextView.layer.borderColor = UIColor.black.cgColor
        notesTextView.layer.borderWidth = 1.0
        saveBtnUI.layer.borderColor = UIColor.black.cgColor
        saveBtnUI.layer.borderWidth = 1.0
        userAvatar.loadImageWithURL(URL(string: (user.avatar_url))!)
    }

    @IBAction func saveNotes(_ sender: Any) {
        do {
            let request: NSFetchRequest<Users> = Users.fetchRequest()
            request.predicate = NSPredicate(format: "id == \(user.id)")
            let user = try self.context.fetch(request)
            user.first!.notes = notesTextView.text
            do {
                try self.context.save()
            } catch {
                
            }
        } catch {
            print("Error \(error)")
        }
    }

}
