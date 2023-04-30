//
//  Environment.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 27/04/23.
//

import Foundation


struct Environment {
    private let urlBase: String
    
    init(){
        self.urlBase = "https://jsonplaceholder.typicode.com"
    }
    
    func getUsers() -> String {
        return urlBase + "/users"
    }
    
    func getPostByUser(userId: Int) -> String {
        return urlBase + "/posts?userId=\(userId)"
    }
}
