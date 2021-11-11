//
//  SchedulesListInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 12.10.2021.
//

import Foundation

final class SchedulesListInteractor {
    typealias Delegate = SchedulesListInteractorDelegate
    weak var delegate: Delegate?

    var database: DoctorsDatabase?
}

// MARK: - SchedulesListInteraction

extension SchedulesListInteractor: SchedulesListInteraction {
    func getSchedules(for doctor: Doctor, onDate date: Date?) {
        guard let schedulesEntities = database?.readSchedules(for: doctor) else { return }

        let schedules = schedulesEntities
            .compactMap { DoctorSchedule(entity: $0)}
            .filter { Calendar.current.compare($0.startingTime, to: Date(), toGranularity: .day) != .orderedAscending }
            .sorted(by: { $0.startingTime > $1.startingTime })

        guard let date = date else {
            delegate?.schedulesDidRecieved(schedules)
            return
        }

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        delegate?.schedulesDidRecieved(
            schedules.filter {
                Calendar.current.dateComponents([.year, .month, .day], from: $0.startingTime) == dateComponents
            }
        )
    }
}
