//
//  PickDoctorSubscription.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 28.04.2021.
//

import Foundation

protocol PickDoctorSubscription: AnyObject {
    func routeToPickDoctor(from: [Doctor], previouslyPicked: Doctor?, didFinish: @escaping ((Doctor?) -> Void))
}
