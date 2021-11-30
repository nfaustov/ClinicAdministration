//
//  PatientAppointmentSubscription.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 14.11.2021.
//

import Foundation

protocol PatientAppointmentSubscription: AnyObject {
    func routeToPatientAppointment(
        schedule: DoctorSchedule,
        appointment: PatientAppointment,
        didFinish: @escaping (DoctorSchedule?) -> Void
    )
}
