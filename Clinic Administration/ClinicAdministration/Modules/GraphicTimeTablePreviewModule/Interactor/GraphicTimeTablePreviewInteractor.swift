//
//  GraphicTimeTablePreviewInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.05.2021.
//

import Foundation
import Combine

final class GraphicTimeTablePreviewInteractor {
    typealias Delegate = GraphicTimeTablePreviewInteractorDelegate
    weak var delegate: Delegate?

    var database: DoctorDatabase?
    var doctorScheduleService: DoctorScheduleService?

    var subscriptions = Set<AnyCancellable>()
}

// MARK: - GraphicTimeTablePreviewInteraction

extension GraphicTimeTablePreviewInteractor: GraphicTimeTablePreviewInteraction {
//    func getSchedules(for date: Date) {
//        guard let doctorScheduleEntities = database?.readSchedules(for: date) else { return }
//
//        let schedules = doctorScheduleEntities.compactMap { DoctorSchedule(entity: $0) }
//        delegate?.schedulesDidRecieved(schedules)
//    }
//
//    func updateSchedule(_ schedule: DoctorSchedule) {
//        database?.updateSchedule(schedule)
//    }
//
//    func createSchedule(_ schedule: DoctorSchedule) {
//        database?.createDoctorSchedule(schedule)
//        delegate?.scheduleDidCreated(schedule)
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

    func createSchedule(_ schedule: DoctorSchedule) {
        doctorScheduleService?.create(schedule)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    Log.error(error.localizedDescription)
                case .finished: break
                }
            }, receiveValue: { schedule in
                Log.info("Schedule for \(schedule.doctor.fullName) was created")
            })
            .store(in: &subscriptions)
    }
}
