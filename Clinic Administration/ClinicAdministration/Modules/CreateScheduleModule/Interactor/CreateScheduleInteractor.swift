//
//  CreateScheduleInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 27.04.2021.
//

import Foundation

final class CreateScheduleInteractor {
    typealias Delegate = CreateScheduleInteractorDelegate
    weak var delegate: Delegate?

    var database: DoctorsDatabase?
}

// MARK: - CreateScheduleInteraction

extension CreateScheduleInteractor: CreateScheduleInteraction {
    func getSchedules(onDate date: Date, forCabinet cabinet: Int) {
//        guard let schedulesEntities = database?.readSchedules(for: date) else { return }
//
//        let schedules = schedulesEntities
//            .compactMap { DoctorSchedule(entity: $0) }
//            .filter { $0.cabinet == cabinet }
//            .sorted(by: { $0.startingTime < $1.startingTime })
        let dataManager = TimeTableDataManager()
        let schedules = dataManager.filteredSchedules(for: date)
            .filter { $0.cabinet == cabinet }
            .sorted { $0.startingTime < $1.startingTime }
        delegate?.schedulesDidRecieved(schedules, date: date)
    }

    func createSchedule(_ schedule: DoctorSchedule) {
        database?.createDoctorSchedule(schedule)
    }
}
