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
    
    func update(user: Users) {
        usernameLabel.text = user.login
        userAvatar.loadImageWithURL(URL(string: user.avatar_url!)!)
        let thisNotes = user.notes ?? ""
        if thisNotes != "" {
            notesImageView.isHidden = false
        } else {
            notesImageView.isHidden = true
        }
    }
    
}

extension UIImageView {
    func loadImageWithURL(_ url: URL) -> URLSessionDownloadTask {
        let session = URLSession.shared
        
        let downloadTask = session.downloadTask(with: url, completionHandler: { [weak self] url, response, error in
            
            if error == nil, let url = url,
               let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    if let strongSelf = self {
                        strongSelf.image = image
                    }
                }
            }
        })
        downloadTask.resume()
        return downloadTask
    }
}
