//
//  PatientAppointmentPresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 14.11.2021.
//

import Foundation

final class PatientAppointmentPresenter<V, I>: PresenterInteractor<V, I>, PatientAppointmentModule
where V: PatientAppointmentView, I: PatientAppointmentInteraction {
    weak var coordinator: ScheduleCoordinator?
    var didFinish: ((DoctorSchedule?) -> Void)?
}

// MARK: - PatientAppointmentPresentation

extension PatientAppointmentPresenter: PatientAppointmentPresentation {
    func updateSchedule(with newAppointment: PatientAppointment) {
        view?.schedule.updateAppointments(with: newAppointment) { errorMessage in
            guard let errorMessage = errorMessage else { return }

            self.view?.showError(message: errorMessage)
        }

        guard let schedule = view?.schedule else { return }

        interactor.updateSchedule(schedule)
        didFinish?(schedule)
    }
}

// MARK: - PatientAppointmentInteractorDelegate

extension PatientAppointmentPresenter: PatientAppointmentInteractorDelegate {
}
