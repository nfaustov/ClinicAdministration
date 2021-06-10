//
//  PickCabinetSubscription.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 29.04.2021.
//

import Foundation

protocol PickCabinetSubscription: AnyObject {
    func routeToPickCabinet(previouslyPicked: Int?, didFinish: @escaping (Int?) -> Void)
}
