//
//  PatientsSearchSubscription.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 15.12.2022.
//

import Foundation

protocol PatientsSearchSubscription: AnyObject {
    func routeToPatientsSearch(didFInish: @escaping (Patient?) -> Void)
}
