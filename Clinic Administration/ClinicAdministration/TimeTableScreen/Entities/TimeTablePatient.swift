//
//  TimeTablePatient.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation

struct TimeTablePatientCell: Codable, Hashable {
    var scheduledTime: Date
    var duration: TimeInterval
    var patient: TimeTablePatient?
}

struct TimeTablePatient: Codable, Hashable {
    var id: UUID
    var secondName: String
    var firstName: String
    var patronymicName: String
    var phoneNumber: String
}
