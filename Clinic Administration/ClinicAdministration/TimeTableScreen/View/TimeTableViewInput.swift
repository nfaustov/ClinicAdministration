//
//  TimeTableViewInput.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation

protocol TimeTableViewInput: AnyObject {
    func applyInitialSnapshot(ofSchedules: [DoctorSchedule])

    func updatePatientsSection(for indexPath: IndexPath)
}
