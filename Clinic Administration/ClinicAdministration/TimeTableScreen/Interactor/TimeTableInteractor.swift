//
//  TimeTableInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation

final class TimeTableInteractor {
    weak var output: TimeTableInteractorOutput!
}

extension TimeTableInteractor: TimeTableInteractorInput {
    func getSchedules(for date: Date) {
        let timeTableDataManager = TimeTableDataManager()
        let schedules = timeTableDataManager.filteredSchedules(for: date)
        output.schedulesDidRecieved(schedules)
    }
}
