//
//  Database.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 11.05.2021.
//

import Foundation

protocol Database {
    associatedtype Model
    associatedtype Object

    func create(objectWithModel: Model)
    func read() -> [Object]
    func update(changes: (() -> Void)?)
    func delete(object: Object)
}
