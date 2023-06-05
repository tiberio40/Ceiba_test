//
//  PostService.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 5/06/23.
//

import Foundation

class PostService: BaseServices {
    public func getByUser(userId: Int) async -> (Data?, URLResponse?){
        let url = URL(string: getUrl() + "/?userId=\(userId)")!
        let urlRequest = setURLRequest(url: url, httpMethod: "GET")
        do {
            return try await URLSession.shared.data(for: urlRequest)
        } catch {
            return (nil, nil)
        }
    }
}
