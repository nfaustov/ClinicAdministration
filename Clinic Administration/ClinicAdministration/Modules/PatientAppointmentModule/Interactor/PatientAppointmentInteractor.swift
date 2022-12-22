//
//  PatientAppointmentInteractor.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 14.11.2021.
//

import Foundation

final class PatientAppointmentInteractor {
    typealias Delegate = PatientAppointmentInteractorDelegate
    weak var delegate: Delegate?

    var database: DoctorDatabase?
}

// MARK: - PatientAppointmentInteraction

extension PatientAppointmentInteractor: PatientAppointmentInteraction {
    func updateSchedule(_ schedule: DoctorSchedule) {
        database?.updateSchedule(schedule)
    }
}
