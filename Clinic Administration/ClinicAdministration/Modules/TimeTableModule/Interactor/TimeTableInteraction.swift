//
//  TimeTableInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation

final class TimeTableInteractor {
    typealias Delegate = TimeTableInteractorDelegate
    weak var delegate: Delegate?

    var database: DoctorsDatabase?
}

// MARK: - TimeTableInteraction

extension TimeTableInteractor: TimeTableInteraction {
    func getSchedules(for date: Date) {
        guard let schedulesEntities = database?.readSchedules(for: date) else { return }

        let schedules = schedulesEntities.compactMap { DoctorSchedule(entity: $0) }
        delegate?.schedulesDidRecieved(schedules)
    }
}
