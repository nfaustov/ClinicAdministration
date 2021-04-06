//
//  TimeTableDisplaying.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation

protocol TimeTableDisplaying: AnyObject {
    func applyInitialSnapshot(ofSchedules: [DoctorSchedule])

    func update(for schedule: DoctorSchedule)
}
