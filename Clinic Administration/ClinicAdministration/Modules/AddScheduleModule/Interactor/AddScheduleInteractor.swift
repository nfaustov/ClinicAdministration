//
//  AddScheduleInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.05.2021.
//

import Foundation

final class AddScheduleInteractor {
    typealias Delegate = AddScheduleInteractorDelegate
    weak var delegate: Delegate?

    var database: DoctorsDatabase?
}

// MARK: - AddScheduleInteraction

extension AddScheduleInteractor: AddScheduleInteraction {
    func getSchedules(for date: Date) {
        guard let doctorScheduleEntities = database?.readSchedules(for: date) else { return }

        let schedules = doctorScheduleEntities.compactMap { DoctorSchedule(entity: $0) }
        delegate?.schedulesDidRecieved(schedules)
    }

    func addSchedule(_ schedule: DoctorSchedule) {
        database?.createDoctorSchedule(schedule)
    }
}
