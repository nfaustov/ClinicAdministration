//
//  PatientAppointmentPresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 14.11.2021.
//

import Foundation

final class PatientAppointmentPresenter<V, I>: PresenterInteractor<V, I>, PatientAppointmentModule
where V: PatientAppointmentView, I: PatientAppointmentInteraction {
    weak var coordinator: (PatientsSearchSubscription &
                           PatientCardSubscription)?
    var didFinish: ((DoctorSchedule?) -> Void)?
}

// MARK: - PatientAppointmentPresentation

extension PatientAppointmentPresenter: PatientAppointmentPresentation {
    func findPatient() {
        coordinator?.routeToPatientsSearch { patient in
            guard let patient = patient else { return }

            self.view?.inputData(with: patient)
        }
    }

    func showPatientCard(patient: Patient) {
        coordinator?.routeToPatientCard(patient: patient)
    }

    func updateSchedule(with newAppointment: PatientAppointment) {
        view?.schedule.updateAppointments(with: newAppointment)

        guard let schedule = view?.schedule else { return }

        interactor.updateSchedule(schedule)
        didFinish?(schedule)
    }
}

// MARK: - PatientAppointmentInteractorDelegate

extension PatientAppointmentPresenter: PatientAppointmentInteractorDelegate {
}
