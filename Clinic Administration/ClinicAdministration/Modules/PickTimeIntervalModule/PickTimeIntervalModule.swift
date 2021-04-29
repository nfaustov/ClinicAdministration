//
//  PickTimeIntervalModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 29.04.2021.
//

import Foundation

protocol PickTimeIntervalModule: AnyObject {
    var didFinish: ((Date?, Date?) -> Void)? { get set }
}

protocol PickTimeIntervalDisplaying: View { }

protocol PickTimeIntervalPresentation: AnyObject {
    func didFinish(with interval: (Date?, Date?))
}
