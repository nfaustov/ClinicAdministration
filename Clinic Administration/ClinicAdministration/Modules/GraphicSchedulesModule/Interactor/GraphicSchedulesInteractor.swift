//
//  GraphicSchedulesInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.05.2021.
//

import Foundation

final class GraphicSchedulesInteractor {
    typealias Delegate = GraphicSchedulesInteractorDelegate
    weak var delegate: Delegate?
}

// MARK: - GraphicSchedulesInteraction

extension GraphicSchedulesInteractor: GraphicSchedulesInteraction {
    func getSchedules(for date: Date) {
        let timeTableManager = TimeTableDataManager()
        let schedules = timeTableManager.filteredSchedules(for: date)
        delegate?.schedulesDidRecieved(schedules)
    }
}
