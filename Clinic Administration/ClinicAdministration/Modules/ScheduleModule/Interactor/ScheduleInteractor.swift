//
//  ScheduleInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation
import Combine

final class ScheduleInteractor {
    typealias Delegate = ScheduleInteractorDelegate
    weak var delegate: Delegate?

    var database: DoctorDatabase?
    var doctorScheduleService: DoctorScheduleService?

    var subscriptions = Set<AnyCancellable>()
}

// MARK: - ScheduleInteraction

extension ScheduleInteractor: ScheduleInteraction {
//    func getSchedules(for date: Date) {
//        guard let schedulesEntities = database?.readSchedules(for: date) else { return }
//
//        let schedules = schedulesEntities
//            .compactMap { DoctorSchedule(entity: $0) }
//            .sorted(by: { $0.startingTime < $1.startingTime })
//        delegate?.schedulesDidRecieved(schedules)
//    }
//
//    func getDoctorsNextSchedule(after currentSchedule: DoctorSchedule) {
//        guard let schedulesEntities = database?.readSchedules(for: currentSchedule.doctor) else { return }
//
//        let schedules = schedulesEntities
//            .compactMap { DoctorSchedule(entity: $0) }
//            .filter { $0.startingTime > currentSchedule.startingTime }
//            .sorted(by: { $0.startingTime < $1.startingTime })
//        delegate?.scheduleDidRecieved(schedules.first)
//    }
//
//    func deleteSchedule(_ schedule: DoctorSchedule) {
//        database?.deleteSchedule(schedule)
//    }

    func getSchedules(for date: Date) {
        doctorScheduleService?.getSchedulesByDate(date)
            .receive(on: RunLoop.main)
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

    func getDoctorsNextSchedule(after currentSchedule: DoctorSchedule) {
        doctorScheduleService?.getSchedulesByDoctor(currentSchedule.doctor.id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    Log.error(error.localizedDescription)
                case .finished: break
                }
            }, receiveValue: { [delegate] schedules in
                delegate?.scheduleDidRecieved(schedules.first)
            })
            .store(in: &subscriptions)
        
    }

    func deleteSchedule(_ schedule: DoctorSchedule) {
        doctorScheduleService?.deleteSchedule(schedule.id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    Log.error(error.localizedDescription)
                case .finished: break
                }
            }, receiveValue: { schedule in
                Log.info("Successfully deleted schedule for doctor \(schedule.doctor.fullName)")
            })
            .store(in: &subscriptions)
    }
}
