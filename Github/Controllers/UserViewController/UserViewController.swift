//
//  UserViewController.swift
//  Github
//
//  Created by Ruel Lafuente on 9/25/21.
//

import UIKit
import CoreData
import SkeletonView

class UserViewController: UIViewController, UITableViewDelegate, SkeletonTableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate {

    var users:[Users]?
    let context = CoreDataStack.shared.mainContext
    var pagination = Int()
    var isPaginate = true
    @IBOutlet weak var UserTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadController()
    }
    
    func loadController() {
        UserTableView.delegate = self
        UserTableView.dataSource = self
        UserTableView.rowHeight = 50.0
        UserTableView.estimatedRowHeight = 50.0
        UserTableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        searchBar.delegate = self
        UserTableView.isSkeletonable = true
        UserTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .gray), animation: nil, transition: .crossDissolve(0.25))
        
        do {
            users = UserManager.shared.fetchUsers()
            pagination = users!.count == 0 ? users!.count : Int((users?.last?.id)!)
            
        } catch {
            print("Error \(error)")
        }
        
        if users!.count == 0 {
            getUsers()
        }
    }
    
    func getUsers() {
        let urlString = "\(GlobalVariable.getUsersApi)\(pagination)"
        print(urlString)
        var thisUsers = [User]()
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                thisUsers = parseJson(json: data)
            } else {
                makeTableViewScrollable()
            }
        } else {
            makeTableViewScrollable()
        }
        
        for user in thisUsers {
            let urlString = "\(GlobalVariable.getUserProfile)\(user.login)"
            print(urlString)
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    let decoder = JSONDecoder()
                    if let userProfile = try? decoder.decode(Profile.self, from: data) {
                        print(userProfile)
                        if !UserManager.shared.userExist(id: userProfile.id) {
                            UserManager.shared.createUser(profile: userProfile)
                        }
                    }
                }
            }
            if user.id == thisUsers.last!.id {
                pagination = user.id
                users = UserManager.shared.fetchUsers()
                makeTableViewScrollable()
            }
        }
    }
    
    func makeTableViewScrollable() {
        isPaginate = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.UserTableView.tableFooterView = nil
//            self.UserTableView.isScrollEnabled = true
            self.UserTableView.reloadData()
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async {
            if searchText.count > 0 {
                do {
                    self.users = UserManager.shared.searchUsers(searchText: searchText)
                    self.UserTableView.reloadData()
                } catch {
                    print("Error \(error)")
                }
            } else {
                self.users = UserManager.shared.fetchUsers()
                self.UserTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            if searchBar.text == "" {
                users = UserManager.shared.fetchUsers()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.UserTableView.stopSkeletonAnimation()
                    self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                    self.UserTableView.reloadData()
                    
                })
            }
        } catch {
            print("Error \(error)")
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "UserCell"
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > ((UserTableView.contentSize.height + 50) - scrollView.frame.size.height) {
            print("isPaginate",isPaginate)
            if isPaginate {
                isPaginate = false
                pagination = Int((users?.last!.id)!)
                self.UserTableView.tableFooterView = createSpinner()
//                self.UserTableView.isScrollEnabled = false
                getUsers()
            }
        }
    }
    
    func createSpinner() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        if traitCollection.userInterfaceStyle == .dark {
            spinner.color = .white
        } else {
            spinner.color = .black
        }
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let viewController = segue.destination as! DetailViewController
            let selectedRow = sender as? Int
            let user = users![selectedRow!]
            let thiUser = Profile(id: Int(user.id), login: user.login!, avatar_url: user.avatar_url!, following: Int(user.following), followers: Int(user.followers), bio: user.bio, name: user.name, company: user.company, blog: user.blog, notes: user.notes, isSeen: user.isSeen)
            viewController.user = thiUser
            let index = selectedRow! + 1
            viewController.imageInverted = index.divisibleByFour()
        }
    }

}
