//
//  CreateScheduleInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 27.04.2021.
//

import Foundation
import Combine

final class CreateScheduleInteractor {
    typealias Delegate = CreateScheduleInteractorDelegate
    weak var delegate: Delegate?

    var database: DoctorDatabase?
    var doctorScheduleService: DoctorScheduleService?

    var subscriptions = Set<AnyCancellable>()
}

// MARK: - CreateScheduleInteraction

extension CreateScheduleInteractor: CreateScheduleInteraction {
//    func getSchedules(onDate date: Date, forCabinet cabinet: Int) {
//        guard let schedulesEntities = database?.readSchedules(for: date) else { return }
//
//        let schedules = schedulesEntities
//            .compactMap { DoctorSchedule(entity: $0) }
//            .filter { $0.cabinet == cabinet }
//            .sorted(by: { $0.startingTime < $1.startingTime })
//        delegate?.schedulesDidRecieved(schedules, date: date)
//    }

    func getSchedules(onDate date: Date, forCabinet cabinet: Int) {
        doctorScheduleService?.getSchedulesByDate(date)
            .sink(receiveCompletion: { [delegate] completion in
                switch completion {
                case .failure(let error):
                    Log.error(error.localizedDescription)
                    delegate?.schedulesDidRecieved([], date: date)
                case .finished: break
                }
            }, receiveValue: { [delegate] schedules in
                let filteredSchedules = schedules
                    .filter { $0.cabinet == cabinet }
                    .sorted(by: { $0.startingTime < $1.startingTime })
                delegate?.schedulesDidRecieved(filteredSchedules, date: date)
            })
            .store(in: &subscriptions)
    }
}
