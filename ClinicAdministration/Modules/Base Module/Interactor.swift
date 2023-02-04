//
//  Interactor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.04.2021.
//

import Foundation

protocol Interactor: AnyObject {
    associatedtype Delegate
    var delegate: Delegate? { get set }
}
