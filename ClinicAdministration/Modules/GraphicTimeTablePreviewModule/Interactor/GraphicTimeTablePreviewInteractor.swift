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
    func getSchedules(for date: Date) {
        doctorScheduleService?.getSchedulesByDate(date)
            .sink(receiveCompletion: { [delegate] completion in
                switch completion {
                case .failure(let error):
                    delegate?.schedulesDidRecieved([])
                    delegate?.scheduleFailure(message: error.localizedDescription)
                case .finished: break
                }
            }, receiveValue: { [delegate] schedules in
                delegate?.schedulesDidRecieved(schedules)
            })
            .store(in: &subscriptions)
    }

    func updateSchedule(_ schedule: DoctorSchedule) {
        doctorScheduleService?.updateSchedule(schedule)
            .sink(receiveCompletion: { [delegate] completion in
                switch completion {
                case .failure(let error):
                    delegate?.scheduleFailure(message: "Не удалось обновить расписание. \(error.localizedDescription)")
                case .finished: break
                }
            }, receiveValue: { [delegate] schedule in
                delegate?.scheduleDidUpdated(schedule)
            })
            .store(in: &subscriptions)
    }

    func createSchedule(_ schedule: DoctorSchedule) {
        doctorScheduleService?.create(schedule)
            .sink(receiveCompletion: { [delegate] completion in
                switch completion {
                case .failure(let error):
                    delegate?.scheduleFailure(message: "Не удалось создать расписание. \(error.localizedDescription)")
                case .finished: break
                }
            }, receiveValue: { [delegate] schedule in
                print(schedule.starting)
                delegate?.scheduleDidCreated(schedule)
            })
            .store(in: &subscriptions)
    }
}
