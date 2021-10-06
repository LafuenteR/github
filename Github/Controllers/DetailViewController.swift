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
    var imageInverted: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadController()
    }
    
    func loadController() {
        UIupdate()
        followersLabel.text = "\(Translation.followers) \(user.followers)"
        followingLabel.text = "\(Translation.following) \(user.following)"
        userInfoTextView.text = "\(Translation.name) \(user.name ?? "")\n\(Translation.company) \(user.company ?? Translation.na) \n\(Translation.blog) \((user.blog ?? Translation.na))"
        notesTextView.text = user.notes
        updateUser(isUpdateNotes: false)
        updateBorderWidth()
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func UIupdate() {
        self.title = user.name
        ImageService.getImage(url: URL(string: user.avatar_url)!, completion: { image in
            if self.imageInverted {
                self.userAvatar.image = image?.invertedImage()
            } else {
                self.userAvatar.image = image
            }
        })
        darkMode()
    }
    
    func updateBorderWidth() {
        userInfoTextView.layer.borderWidth = 1.0
        notesTextView.layer.borderWidth = 1.0
        saveBtnUI.layer.borderWidth = 1.0
    }

    @IBAction func saveNotes(_ sender: Any) {
        updateUser(isUpdateNotes: true)
    }
    
    func updateUser(isUpdateNotes: Bool) {
        do {
            let request: NSFetchRequest<Users> = Users.fetchRequest()
            request.predicate = NSPredicate(format: "id == \(user.id)")
            let user = try self.context.fetch(request)
            if isUpdateNotes {
                self.view.endEditing(true)
                user.first!.notes = notesTextView.text
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
    
    func darkMode() {
        if traitCollection.userInterfaceStyle == .dark {
            updateColor(updateTextColor: .white)
        } else {
            updateColor(updateTextColor: .black)
        }
    }
    
    func updateColor(updateTextColor: UIColor) {
        notesTextView.layer.borderColor = updateTextColor.cgColor
        saveBtnUI.layer.borderColor = updateTextColor.cgColor
        userInfoTextView.layer.borderColor = updateTextColor.cgColor
        saveBtnUI.tintColor = updateTextColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        print(keyboardFrame.height, self.view.frame.height)
        if (self.view.frame.origin.y == 0) {
            self.view.frame.origin.y -= keyboardFrame.height - (self.view.frame.height - keyboardFrame.height > 400 ? self.view.frame.height - keyboardFrame.height - 250 : 0)
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if(self.view.frame.origin.y != 0){
            self.view.frame.origin.y = 0
        }
    }

}
