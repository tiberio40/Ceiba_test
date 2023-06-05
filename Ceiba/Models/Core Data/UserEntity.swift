//
//  DataSourceImpl.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 5/05/23.
//

import Foundation
import CoreData
import UIKit


struct UserEntity: DataSource {
    
    var context: NSManagedObjectContext?
    
    init(){
        let container = NSPersistentContainer(name: "Ceiba")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }            
        })
        context = container.viewContext
    }
    
    func getAll<T>() throws -> Result<[T], Error> where T : NSManagedObject {
        do{
            let request = T.fetchRequest()
            let result = try self.context?.fetch(request) as! [T]
            return .success(result)
        }catch let error {
            return .failure(error)
        }
    }
    
    func getById<T>(_ id: Int32) async throws -> Result<T, Error> where T : NSManagedObject {
        do{
            let request = T.fetchRequest()
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "id = %@", id)
            let result = try context?.fetch(request)[0] as! T
            return .success(result)
        }catch let error {
            return .failure(error)
        }
    }
    
    func create<T>(todo: T) throws where T : Decodable {
        
        let user = User(context: self.context!)
        let mirror = Mirror(reflecting: todo)
        for child in mirror.children  {
            user.setValue(child.value, forKey: child.label!)
        }
        
        do {
            try context?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
