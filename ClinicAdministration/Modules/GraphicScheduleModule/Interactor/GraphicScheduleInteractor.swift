//
//  GraphicScheduleInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 13.04.2021.
//

import Foundation
import Combine

final class GraphicScheduleInteractor {
    typealias Delegate = GraphicScheduleInteractorDelegate
    weak var delegate: Delegate?

    var database: DoctorDatabase?
    var doctorScheduleService: DoctorScheduleService?

    private var subscriptions = Set<AnyCancellable>()
}

// MARK: - GraphicScheduleInteraction

extension GraphicScheduleInteractor: GraphicScheduleInteraction {
//    func getSchedules(for date: Date) {
//        guard let schedulesEntities = database?.readSchedules(for: date) else { return }
//
//        let schedules = schedulesEntities.compactMap { DoctorSchedule(entity: $0) }
//        delegate?.schedulesDidRecieved(schedules)
//    }
//
//    func updateSchedule(_ schedule: DoctorSchedule) {
//        database?.updateSchedule(schedule)
//    }

    func getSchedules(for date: Date) {
        doctorScheduleService?.getSchedulesByDate(date)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    Log.error(error.localizedDescription)
                case .finished: break
                }
            }, receiveValue: { [delegate] schedules in
                delegate?.schedulesDidRecieved(schedules)
            })
            .store(in: &subscriptions)
    }

    func updateSchedule(_ schedule: DoctorSchedule) {
        doctorScheduleService?.updateSchedule(schedule)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    Log.error(error.localizedDescription)
                case .finished: break
                }
            }, receiveValue: { schedule in
                Log.info("Schedule for \(schedule.doctor.fullName) was updated")
            })
            .store(in: &subscriptions)
    }
}
