//
//  UserPostsController.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 29/04/23.
//

import UIKit
import CoreData

class UserPostsController: UITableViewController {
    
    var user: UserDTO?
    var userPosts: [PostDTO] = []
    var context: NSManagedObjectContext?
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        guard let user = self.user else {
            return
        }
        
        
        self.nameLabel.text = user.name
        self.nicknameLabel.text = user.username
        self.telephoneLabel.text = user.phone
        self.emailLabel.text = user.email
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.context = appDelegate.persistentContainer.viewContext
            self.getUserPosts()
            
        }else{
            self.loadDataFromAPI(userId: user.id)
        }
        
        super.viewDidLoad()
    }
    
    
    func getUserPosts() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
        request.predicate = NSPredicate(format: "userId == \(self.user!.id)")
        
        do {
            let fetchedPosts = try self.context!.fetch(request)
            
            if(fetchedPosts.count == 0){
                self.loadDataFromAPI(userId: self.user!.id)
            }else {
                let data = fetchedPosts as! [Post]
                
                self.userPosts = data.map{(item) -> PostDTO in
                    return PostDTO(
                        userId: Int(item.userId),
                        id: Int(item.id),
                        title: item.title!,
                        body: item.body!
                    )
                }
            }
        }catch {
            
        }
    }
    
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
        cell.setValues(userPost: self.userPosts[indexPath.row])
        
        return cell
    }
    
    func loadDataFromAPI(userId: Int){
        let enviroment = Environment()
        
        guard let url = URL(string: enviroment.getPostByUser(userId: userId)) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            guard let data = data else { return }
            
            do{
                let jsonResponse = try JSONDecoder().decode([PostDTO].self, from: data)
                self.userPosts = jsonResponse
                
                if let context = self.context {
                    for post in self.userPosts {
                        let newPost = NSEntityDescription.insertNewObject(forEntityName: "Post", into: context)
                        newPost.setValue(post.body, forKey: "body")
                        newPost.setValue(post.id, forKey: "id")
                        newPost.setValue(post.title, forKey: "title")
                        newPost.setValue(post.userId, forKey: "userId")
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
}
