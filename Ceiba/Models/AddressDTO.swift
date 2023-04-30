//
//  AddressDTO.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 27/04/23.
//

import Foundation


struct AddressDTO: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: GeoDTO
}
