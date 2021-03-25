//
//  DoctorSchedule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import Foundation

struct DoctorSchedule: Codable, Equatable {
    let id: UUID
    var secondName: String
    var firstName: String
    var patronymicName: String
    var cabinet: Int
    var startingTime: Date
    var endingTime: Date
}
