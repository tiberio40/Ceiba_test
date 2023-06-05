//
//  DataParser.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 5/05/23.
//

import Foundation


struct DataParser<T: Decodable> {
    
    func parse(data: Data) -> Result<T, Error> {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedData)
        } catch let error {
            return .failure(error)
        }
    }
    
}
