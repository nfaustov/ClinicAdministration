//
//  DoctorSchedule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import Foundation

struct DoctorSchedule: Codable, Equatable, Hashable {
    let id: UUID
    var secondName: String
    var firstName: String
    var patronymicName: String
    var phoneNumber: String
    var specialization: String
    var cabinet: Int
    var startingTime: Date
    var endingTime: Date
    var serviceDuration: TimeInterval
    var patientCells: [TimeTablePatientCell]
}
