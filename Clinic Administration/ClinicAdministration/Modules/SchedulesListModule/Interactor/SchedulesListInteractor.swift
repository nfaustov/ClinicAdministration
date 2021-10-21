//
//  SchedulesListInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 12.10.2021.
//

import Foundation

final class SchedulesListInteractor {
    typealias Delegate = SchedulesListInteractorDelegate
    weak var delegate: Delegate?

    var database: DoctorsDatabase?
}

// MARK: - SchedulesListInteraction

extension SchedulesListInteractor: SchedulesListInteraction {
    func getSchedules(for doctor: Doctor) {
        guard let schedulesEntities = database?.readSchedules(for: doctor) else { return }

        let schedules = schedulesEntities
            .compactMap { DoctorSchedule(entity: $0)}
            .sorted(by: { $0.startingTime > $1.startingTime })
        delegate?.schedulesDidRecieved(schedules)
    }
}
