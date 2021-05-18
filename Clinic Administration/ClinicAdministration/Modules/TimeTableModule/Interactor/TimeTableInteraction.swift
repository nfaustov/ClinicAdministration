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

    var firstLaunch: Bool = true
}

// MARK: - TimeTableInteraction

extension TimeTableInteractor: TimeTableInteraction {
    func getSchedules(for date: Date) {
        if firstLaunch {
            database?.createMockData()
            firstLaunch = false
        }
//        let timeTableDataManager = TimeTableDataManager()
//        let schedules = timeTableDataManager.filteredSchedules(for: date)
        guard let schedulesEntities = database?.readSchedules(for: date) else { return }

        let schedules = schedulesEntities.compactMap { DoctorSchedule(entity: $0) }
        delegate?.schedulesDidRecieved(schedules)
    }
}
