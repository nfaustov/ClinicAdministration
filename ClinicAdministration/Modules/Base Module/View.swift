//
//  View.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.04.2021.
//

import Foundation

protocol View: AnyObject {
    associatedtype PresenterType
    var presenter: PresenterType! { get set }
}
