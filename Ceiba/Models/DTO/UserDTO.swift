//
//  UserDTO.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 27/04/23.
//

import Foundation

struct UserDTO: Codable{
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String

//    let address: AddressDTO
//    let website: String
//    let company: CompanyDTO
}
