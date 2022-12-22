//
//  GraphicTimeTablePreviewInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.05.2021.
//

import Foundation

final class GraphicTimeTablePreviewInteractor {
    typealias Delegate = GraphicTimeTablePreviewInteractorDelegate
    weak var delegate: Delegate?

    var database: DoctorDatabase?
}

// MARK: - GraphicTimeTablePreviewInteraction

extension GraphicTimeTablePreviewInteractor: GraphicTimeTablePreviewInteraction {
    func getSchedules(for date: Date) {
        guard let doctorScheduleEntities = database?.readSchedules(for: date) else { return }

        let schedules = doctorScheduleEntities.compactMap { DoctorSchedule(entity: $0) }
        delegate?.schedulesDidRecieved(schedules)
    }

    func updateSchedule(_ schedule: DoctorSchedule) {
        database?.updateSchedule(schedule)
    }

    func createSchedule(_ schedule: DoctorSchedule) {
        database?.createDoctorSchedule(schedule)
        delegate?.scheduleDidCreated(schedule)
    }
}
