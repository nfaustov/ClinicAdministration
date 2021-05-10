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
}

// MARK: - AddScheduleInteraction

extension AddScheduleInteractor: AddScheduleInteraction {
    func getSchedules(for date: Date) {
        let timeTableManager = TimeTableDataManager()
        let schedules = timeTableManager.filteredSchedules(for: date)
        delegate?.schedulesDidRecieved(schedules)
    }
}
