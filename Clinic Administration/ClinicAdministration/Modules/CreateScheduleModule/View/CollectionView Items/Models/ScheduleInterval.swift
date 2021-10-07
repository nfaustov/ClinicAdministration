//
//  ScheduleInterval.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 11.06.2021.
//

import Foundation

struct ScheduleInterval: Hashable {
    var starting: Date
    var ending: Date

    static let defaultInterval = ScheduleInterval(starting: Date(), ending: Date())
}
