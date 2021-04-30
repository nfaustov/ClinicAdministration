//
//  PickTimeIntervalSubscription.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 29.04.2021.
//

import Foundation

protocol PickTimeIntervalSubscription: AnyObject {
    func routeToPickTimeInterval(date: Date, didFinish: @escaping ((Date?, Date?) -> Void))
}
