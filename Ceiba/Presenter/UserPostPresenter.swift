//
//  UserPostPresenter.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 4/06/23.
//

import Foundation
import CoreData

protocol UserPostViewPresenter: AnyObject  {
    func loadInfoTable(userPosts: [PostDTO])
}

class UserPostPresenter {
    private let user: UserDTO
    
    weak var view: UserPostViewPresenter?
    
    var context: NSManagedObjectContext? = {
        let container = NSPersistentContainer(name: "Ceiba")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }().viewContext
    
    init(viewPresenter: UserPostViewPresenter, user: UserDTO) {
        self.view = viewPresenter
        self.user = user
        
        self.getUserPosts()
    }
    
    func getUserPosts() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
        request.predicate = NSPredicate(format: "userId == \(self.user.id)")
        
        do {
            let fetchedPosts = try self.context?.fetch(request)
            
            if(fetchedPosts?.count == 0){
                self.loadDataFromAPI(userId: self.user.id)
            }else {
                let data = fetchedPosts as! [Post]
                let userPosts = data.map{(item) -> PostDTO in
                    return PostDTO(
                        userId: Int(item.userId),
                        id: Int(item.id),
                        title: item.title!,
                        body: item.body!
                    )
                }
                self.view?.loadInfoTable(userPosts: userPosts)
            }
        }catch {
            
        }
    }
    
    func loadDataFromAPI(userId: Int){
        let _postServices = PostService(urlSubDominio: "/posts")
        
        Task{
            let (response, _) = await _postServices.getByUser(userId: self.user.id)
            
            guard let data = response else {
//                self.view?.showErrorService(status: MenssageEnum.withoutConnection)
                return
            }
            let dataParser = DataParser<[PostDTO]>()
            let result = dataParser.parse(data: data)
            
            switch result{
            case .success(let userPosts):
                do{
                    let postEntity = PostEntity()

                    for userPost in userPosts {
                        try postEntity.create(todo: userPost)
                    }
                }catch{

                }
                self.view?.loadInfoTable(userPosts: userPosts)
            case .failure(_):
                print("Error")
            }
        }
        
    }
}
