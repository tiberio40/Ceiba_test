//
//  PostDTO.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 29/04/23.
//

import Foundation

struct PostDTO: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
