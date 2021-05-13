//
//  DoctorSchedule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import Foundation

struct DoctorSchedule: Codable, Equatable, Hashable {
    let id: UUID
    let doctor: Doctor
    var cabinet: Int
    var startingTime: Date
    var endingTime: Date
    var patientAppointments: [PatientAppointment]
}
