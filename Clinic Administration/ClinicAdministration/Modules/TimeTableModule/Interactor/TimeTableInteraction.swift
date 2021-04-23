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
}

// MARK: - TimeTableInteraction

extension TimeTableInteractor: TimeTableInteraction {
    func getSchedules(for date: Date) {
        let timeTableDataManager = TimeTableDataManager()
        let schedules = timeTableDataManager.filteredSchedules(for: date)
        delegate?.schedulesDidRecieved(schedules)
    }
}
