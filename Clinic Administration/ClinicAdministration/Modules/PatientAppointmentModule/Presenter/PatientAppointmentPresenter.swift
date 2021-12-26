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
    var didFinish: ((DoctorSchedule?) -> Void)?
}

// MARK: - PatientAppointmentPresentation

extension PatientAppointmentPresenter: PatientAppointmentPresentation {
    func updateSchedule(with newApointment: PatientAppointment) {
        view?.schedule.updateAppointments(with: newApointment) { errorMessage in
            guard let errorMessage = errorMessage else { return }

            self.view?.showError(message: errorMessage)
        }
    }
}

// MARK: - PatientAppointmentInteractorDelegate

extension PatientAppointmentPresenter: PatientAppointmentInteractorDelegate {
}
