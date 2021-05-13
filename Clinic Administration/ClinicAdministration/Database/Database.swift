//
//  Database.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 11.05.2021.
//

import Foundation

protocol Database {
    associatedtype Object

    func create(object: Object)
    func read() -> [Object]
    func update(changes: (() -> Void)?)
    func delete(object: Object)
}
