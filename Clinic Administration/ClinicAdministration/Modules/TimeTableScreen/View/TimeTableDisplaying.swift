//
//  TimeTableDisplaying.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation

protocol TimeTableDisplaying: AnyObject {
    var date: Date { get set }

    func daySnapshot(schedules: [DoctorSchedule])

    func doctorSnapshot(schedule: DoctorSchedule)
}
