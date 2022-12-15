//
//  PatientsSearchPresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 15.12.2022.
//

import Foundation

final class PatientsSearchPresenter<V, I>: PresenterInteractor<V, I>,
                                           PatientsSearchModule where V: PatientsSearchView,
                                                                      I: PatientsSearchInteraction {
    var didFinish: ((Patient?) -> Void)?
}

// MARK: - PatientsSearchPresentaion

extension PatientsSearchPresenter: PatientsSearchPresentation {
    func patientsRequest() {
        interactor.getPatients()
    }

    func performQuery(with text: String) {
        guard let patients = view?.resultList else { return }

        let filteredPatients = patients.filter { patient in
            if text.isEmpty { return true }
            let lowercasedFilter = text.lowercased()

            return patient.fullName.lowercased().contains(lowercasedFilter)
        }

        view?.patientsSnapshot(filteredPatients)
    }

    func didFinish(with patient: Patient?) {
        didFinish?(patient)
    }
}

// MARK: - PatientsSearchInteractorDelegate

extension PatientsSearchPresenter: PatientsSearchInteractorDelegate {
    func patientsDidRecieved(_ patients: [Patient]) {
        view?.resultList = patients
        view?.patientsSnapshot(patients)
    }
}
