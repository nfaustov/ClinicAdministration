//
//  PatientAppointmentPresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 14.11.2021.
//

import Foundation

final class PatientAppointmentPresenter<V, I>: PresenterInteractor<V, I>, PatientAppointmentModule
where V: PatientAppointmentView, I: PatientAppointmentInteraction {
    weak var coordinator: TimeTableCoordinator?
    var didFinish: ((PatientAppointment) -> Void)?
}

// MARK: - PatientAppointmentPresentation

extension PatientAppointmentPresenter: PatientAppointmentPresentation {
}

// MARK: - PatientAppointmentInteractorDelegate

extension PatientAppointmentPresenter: PatientAppointmentInteractorDelegate {
}
