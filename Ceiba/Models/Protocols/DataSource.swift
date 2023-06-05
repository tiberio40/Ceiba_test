//
//  DataSource.swift
//  Ceiba
//
//  Created by Laurent Castañeda on 5/05/23.
//

import Foundation
import CoreData

protocol DataSource {
    func getAll<T: NSManagedObject>() throws -> Result<[T], Error>
    func getById<T: NSManagedObject>(_ id: Int32) async throws -> Result<T, Error>
//    func delete(_ id: UUID) async throws -> ()
    func create<T: Decodable>(todo: T) throws -> ()
//    func update<T: Decodable>(id: UUID, item: T) async throws -> ()
}
