//
//  UserCell.swift
//  Github
//
//  Created by Ruel Lafuente on 9/25/21.
//

import UIKit
import CoreData

class UserCell: UITableViewCell {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var notesImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        userAvatar.layer.cornerRadius = userAvatar.bounds.height / 2
        userAvatar.clipsToBounds = true
    }
    
    func update(user: Users, index: Int) {
        usernameLabel.text = user.login
        if user.isSeen {
            updateColor(updateTextColor: .gray)
        } else {
//            updateColor(updateTextColor: .black)
            darkMode()
        }
        ImageService.getImage(url: URL(string: user.avatar_url!)!, completion: { image in
            if index.divisibleByFour() {
                self.userAvatar.image = image?.invertedImage()
            } else {
                self.userAvatar.image = image
            }
        })
        let thisNotes = user.notes ?? ""
        if thisNotes != "" {
            notesImageView.isHidden = false
        } else {
            notesImageView.isHidden = true
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
        usernameLabel.textColor = updateTextColor
        detailsLabel.textColor = updateTextColor
        notesImageView.tintColor = updateTextColor
    }
}
