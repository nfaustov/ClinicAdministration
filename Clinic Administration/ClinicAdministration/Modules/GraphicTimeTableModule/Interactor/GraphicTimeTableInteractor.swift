//
//  GraphicTimeTableInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 13.04.2021.
//

import Foundation

final class GraphicTimeTableInteractor {
    typealias Delegate = GraphicTimeTableInteractorDelegate
    weak var delegate: Delegate?
}

// MARK: - GraphicTimeTableInteraction

extension GraphicTimeTableInteractor: GraphicTimeTableInteraction {
    func getSchedules(for date: Date) {
        let timeTableDataManager = TimeTableDataManager()
        let schedules = timeTableDataManager.filteredSchedules(for: date)
        delegate?.schedulesDidRecieved(schedules)
    }
}
