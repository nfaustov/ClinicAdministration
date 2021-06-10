//
//  CreateScheduleInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 27.04.2021.
//

import Foundation

final class CreateScheduleInteractor {
    typealias Delegate = CreateScheduleInteractorDelegate
    weak var delegate: Delegate?

    var database: DoctorsDatabase?
}

// MARK: - CreateScheduleInteraction

extension CreateScheduleInteractor: CreateScheduleInteraction {
    func createSchedule(_ schedule: DoctorSchedule) {
        database?.createDoctorSchedule(schedule)
    }
}
