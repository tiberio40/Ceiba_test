//
//  UserPostsController.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 29/04/23.
//

import UIKit
import CoreData

class UserPostsController: UITableViewController {
    
    var presenter: UserPostPresenter?
    
    var user: UserDTO?
    private var userPosts: [PostDTO] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
//                self.tableEmptyView.isHidden = self.searchedUsers.count == 0 ? false: true
            }
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    
    override func viewDidLoad() {
        guard let user = self.user else {
            return
        }
        
        self.presenter = UserPostPresenter(viewPresenter: self, user: user)
        
        self.nameLabel.text = user.name
        self.nicknameLabel.text = user.username
        
        super.viewDidLoad()
    }
}

extension UserPostsController: UserPostViewPresenter {
    func loadInfoTable(userPosts: [PostDTO]) {
        self.userPosts = userPosts
    }
}

extension UserPostsController {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.userPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setValues(userPost: self.userPosts[indexPath.row], user: self.user!)
        
        return cell
    }
}
