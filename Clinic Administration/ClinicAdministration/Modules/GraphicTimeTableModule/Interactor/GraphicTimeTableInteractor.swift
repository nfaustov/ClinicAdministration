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

    var database: DoctorsDatabase?
}

// MARK: - GraphicTimeTableInteraction

extension GraphicTimeTableInteractor: GraphicTimeTableInteraction {
    func getSchedules(for date: Date) {
        guard let schedulesEntities = database?.readSchedules(for: date) else { return }

        let schedules = schedulesEntities.compactMap { DoctorSchedule(entity: $0) }
        delegate?.schedulesDidRecieved(schedules)
    }
}
