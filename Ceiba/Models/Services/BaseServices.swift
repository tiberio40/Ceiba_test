//
//  BaseServices.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 5/05/23.
//

import Foundation


class BaseServices {
    private let urlBase: String = "https://jsonplaceholder.typicode.com"
    private let urlSubDominio: String
    
    init(urlSubDominio: String) {
        self.urlSubDominio = urlSubDominio
    }
    
    public func getUrl() -> String{
        return urlBase + urlSubDominio
    }
    
    
    public func setURLRequest(url: URL, httpMethod: String) -> URLRequest{
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
    
    public func get() async -> (Data?, URLResponse?){
        let url = URL(string: urlBase + urlSubDominio)!
        let urlRequest = setURLRequest(url: url, httpMethod: "GET")
        do {
            return try await URLSession.shared.data(for: urlRequest)
        } catch {
            return (nil, nil)
        }
    }
}
