//
//  DoctorSchedule.swift
//  Clinic Administration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import Foundation

struct DoctorSchedule: Codable, Equatable {
    var secondName: String
    var firstName: String
    var patronymicName: String
    var cabinet: Int
    var startingTime: DateComponents
    var endingTime: DateComponents
}
