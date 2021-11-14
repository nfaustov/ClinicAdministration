//
//  PatientAppointmentSubscription.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 14.11.2021.
//

import Foundation

protocol PatientAppointmentSubscription: AnyObject {
    func routeToPatientAppointment(date: Date, doctor: Doctor, didFinish: @escaping (PatientAppointment?) -> Void)
}
