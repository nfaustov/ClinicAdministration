//
//  GraphicTimeTableInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 13.04.2021.
//

import Foundation

final class GraphicTimeTableInteractor {
    weak var output: GraphicTimeTableInteractorOutput!
}

// MARK: - GraphicTimeTableInteractorInterface

extension GraphicTimeTableInteractor: GraphicTimeTableInteractorInterface {
    func getSchedules(for date: Date) {
        let timeTableDataManager = TimeTableDataManager()
        let schedules = timeTableDataManager.filteredSchedules(for: date)
        output.schedulesDidRecieved(schedules)
    }
}
