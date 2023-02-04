//
//  PatientCardSubscription.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 17.12.2022.
//

import Foundation

protocol PatientCardSubscription: AnyObject {
    func routeToPatientCard(patient: Patient)
}
