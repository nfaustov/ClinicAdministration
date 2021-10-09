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
//        guard let schedulesEntities = database?.readSchedules(for: date) else { return }
//
//        let schedules = schedulesEntities
//            .compactMap { DoctorSchedule(entity: $0) }
//            .sorted(by: { $0.startingTime < $1.startingTime })
        let dataManager = TimeTableDataManager()
        let schedules = dataManager.filteredSchedules(for: date)
            .sorted { $0.startingTime < $1.startingTime }
        delegate?.schedulesDidRecieved(schedules)
    }

    func deleteSchedule(_ schedule: DoctorSchedule) {
        database?.deleteSchedule(schedule)
    }
}
