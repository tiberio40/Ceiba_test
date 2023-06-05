//
//  UsersController.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 27/04/23.
//

import UIKit
import SkeletonView

class UsersController: UITableViewController, UISearchResultsUpdating  {
    var presenter: UserPresenter?
    
    var listUsers: [UserDTO] = []
    var searchedUsers: [UserDTO] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.showMenssageView.setMenssageType(messageType: .noFound)
                self.showMenssageView.isHidden = self.searchedUsers.count == 0 ? false: true
            }
            
        }
    }
    
    var selectedIndexPath: Int = 0
    
    let showMenssageView: ShowMessageView = {
        let tableEmptyView = ShowMessageView(frame: CGRect.zero)
        return tableEmptyView
    }()
    
    
    let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Buscar por nombre"
        return search
    }()
    
    
    override func viewDidLoad() {
        self.presenter = UserPresenter(viewPresenter: self)
        
        self.navigationItem.title = "Prueba de Ingreso"
        self.setupEmptyView()
        
        self.searchController.searchResultsUpdater = self
        navigationItem.searchController = self.searchController
        
        super.viewDidLoad()
    }
    
    func setupEmptyView() {
        view.addSubview(self.showMenssageView)
        self.showMenssageView.frame = view.bounds
        self.showMenssageView.isHidden = true
        self.showMenssageView.setPresenter(presenter: self)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText: String = searchController.searchBar.text ?? ""
        
        if self.listUsers.count == 0 {
            return
        }
        
        if(searchText.isEmpty){
            self.searchedUsers = self.listUsers
        }else{
            self.searchedUsers = self.listUsers.filter{$0.name.localizedStandardContains(searchText)}
        }
        
        self.tableView.reloadData()
    }
    
    
}

extension UsersController: UserViewPresenter{
    func showErrorService(status: MenssageEnum) {
        DispatchQueue.main.async {
            self.showMenssageView.setMenssageType(messageType: .withoutConnection)
            self.showMenssageView.isHidden = false
        }
        
    }
    
    
    func loadInfoTable(users: [UserDTO]) {
        self.listUsers = users
        self.searchedUsers = users
    }
}

extension UsersController: LoadDataProtocol {
    func loadAPIData() {
        
        self.showMenssageView.isHidden = true
        self.presenter?.loadDataFromAPI()
    }
    
    
}

extension UsersController {
    @objc func segueToNextView(_ sender: UIButton) {
        var superview = sender.superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view.superview
        }
        guard let cell = superview as? UITableViewCell else {
            return
        }
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        // We've got the index path for the cell that contains the button, now do something with it.
        
        self.selectedIndexPath = indexPath.row
        
        performSegue(withIdentifier: "detailUserSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailUserSegue"{
            let userPostsController = segue.destination as! UserPostsController
            userPostsController.user = self.searchedUsers[self.selectedIndexPath]
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.listUsers.count == 0 ? 3 : self.searchedUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UsersTableViewCell
        
        if self.searchedUsers.count > 0{
            cell.hideAnimation()
            cell.setValues(user: self.searchedUsers[indexPath.row])
            cell.publicationButton.addTarget(self, action: #selector(segueToNextView(_:)), for: .touchUpInside)
        }
        return cell
    }
}



