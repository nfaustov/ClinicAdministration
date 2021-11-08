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
    func getSchedules(for doctor: Doctor, filteredBy filter: SchedulesListFilter?) {
        guard let schedulesEntities = database?.readSchedules(for: doctor) else { return }

        let schedules = schedulesEntities
            .compactMap { DoctorSchedule(entity: $0)}
            .filter { $0.startingTime > Date() }
            .sorted(by: { $0.startingTime > $1.startingTime })

        guard let filter = filter else {
            delegate?.schedulesDidRecieved(schedules)
            return
        }

        switch filter {
        case .date(let date):
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
            delegate?.schedulesDidRecieved(
                schedules.filter {
                    Calendar.current.dateComponents([.year, .month, .day], from: $0.startingTime) == dateComponents
                }
            )
        case .dateRange(let dateRange):
            delegate?.schedulesDidRecieved(
                schedules.filter { $0.startingTime > dateRange.start && $0.startingTime < dateRange.end }
            )
        }
    }
}

enum SchedulesListFilter {
    case date(Date)
    case dateRange(DateInterval)
}
