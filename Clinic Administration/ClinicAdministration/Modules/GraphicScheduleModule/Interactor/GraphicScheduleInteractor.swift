//
//  GraphicScheduleInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 13.04.2021.
//

import Foundation

final class GraphicScheduleInteractor {
    typealias Delegate = GraphicScheduleInteractorDelegate
    weak var delegate: Delegate?

    var database: DoctorsDatabase?
}

// MARK: - GraphicScheduleInteraction

extension GraphicScheduleInteractor: GraphicScheduleInteraction {
    func getSchedules(for date: Date) {
        guard let schedulesEntities = database?.readSchedules(for: date) else { return }

        let schedules = schedulesEntities.compactMap { DoctorSchedule(entity: $0) }
        delegate?.schedulesDidRecieved(schedules)
    }

    func updateSchedule(_ schedule: DoctorSchedule) {
        database?.updateSchedule(schedule)
    }
}
