//
//  UsersController.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 27/04/23.
//

import UIKit
import CoreData


class UsersController: UITableViewController, UISearchResultsUpdating {
    
    
    
    var listUsers: [UserDTO] = []
    var searchedUsers: [UserDTO] = []
    var indexPath: Int = 0
    var isSearching: Bool = false
    var context: NSManagedObjectContext?
    
    let tableEmptyView = EmptyView(frame: CGRect.zero)
    
    //    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        self.navigationItem.title = "Prueba de Ingreso"
        
        self.setupEmptyView()
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Buscar por nombre"
        navigationItem.searchController = search
        
        
        tableEmptyView.frame = view.bounds
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.context = appDelegate.persistentContainer.viewContext
            self.getUserList()
        }else{
            self.loadDataFromAPI()
        }
        super.viewDidLoad()
    }
    
    func setupEmptyView() {
        view.addSubview(self.tableEmptyView)
        self.tableEmptyView.frame = view.bounds
        self.tableEmptyView.isHidden = true
        
    }
    
    func getUserList() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let query = try self.context!.fetch(request)
            
            if(query.count == 0){
                print("--------No Tiene registros -------")
                self.loadDataFromAPI()
            }else{
                print("-------- Tiene registros -------")
                
                let data = query as! [User]
                
                self.listUsers = data.map{(item) -> UserDTO in
                    return UserDTO(
                        id: Int(item.id),
                        name: item.name!,
                        username: item.username!,
                        email: item.email!,
                        phone: item.phone!,
                        isSync: item.isSync
                    )
                }
            }
            
        }catch {
            
        }
    }
    
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
        
        self.indexPath = indexPath.row
        
        performSegue(withIdentifier: "detailUserSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailUserSegue"{
            let userPostsController = segue.destination as! UserPostsController
            userPostsController.user = self.listUsers[self.indexPath]
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText: String = searchController.searchBar.text ?? ""
        
        if(searchText.isEmpty){
            self.isSearching = false
            self.tableEmptyView.isHidden = true
        }else{
            
            self.searchedUsers = self.listUsers.filter{$0.name.localizedStandardContains(searchText)}
            
            if self.searchedUsers.count == 0 {
                self.tableEmptyView.isHidden = false
            }
            
            self.isSearching = true
        }
        
        self.tableView.reloadData()
    }
    
    func loadDataFromAPI(){
        let enviroment = Environment()
        
        guard let url = URL(string: enviroment.getUsers()) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            guard let data = data else {
                return
            }
            
            do{
                let jsonResponse = try JSONDecoder().decode([UserDTO].self, from: data)
                self.listUsers = jsonResponse
                
                if let context = self.context {
                    for user in self.listUsers {
                        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
                        
                        newUser.setValue(user.id, forKey: "id")
                        newUser.setValue(user.name, forKey: "name")
                        newUser.setValue(user.username, forKey: "username")
                        newUser.setValue(user.phone, forKey: "phone")
                        newUser.setValue(user.email, forKey: "email")
                        newUser.setValue(false, forKey: "isSync")
                    }
                    
                    try context.save()
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch let error{
                print(error)
            }
        }.resume()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.isSearching ? self.searchedUsers.count : self.listUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UsersTableViewCell
        
        cell.setValues(
            user: self.isSearching ? self.searchedUsers[indexPath.row] : self.listUsers[indexPath.row]
        )
        
        cell.publicationButton.addTarget(self, action: #selector(segueToNextView(_:)), for: .touchUpInside)
        return cell
    }
}
