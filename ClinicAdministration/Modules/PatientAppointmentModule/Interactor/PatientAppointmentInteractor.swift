//
//  PatientAppointmentInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 14.11.2021.
//

import Foundation
import Combine

final class PatientAppointmentInteractor {
    typealias Delegate = PatientAppointmentInteractorDelegate
    weak var delegate: Delegate?

    var database: DoctorDatabase?
    var doctorScheduleService: DoctorScheduleService?

    var subscriptions = Set<AnyCancellable>()
}

// MARK: - PatientAppointmentInteraction

extension PatientAppointmentInteractor: PatientAppointmentInteraction {
//    func updateSchedule(_ schedule: DoctorSchedule) {
//        database?.updateSchedule(schedule)
//    }

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
