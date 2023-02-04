//
//  DoctorsSearchPresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 03.06.2021.
//

import Foundation

final class DoctorsSearchPresenter<V, I>: PresenterInteractor<V, I>,
                                          DoctorsSearchModule where V: DoctorsSearchView,
                                                                    I: DoctorsSearchInteraction {
    var didFinish: ((Doctor?) -> Void)?
}

// MARK: - DoctorsSearchPresentation

extension DoctorsSearchPresenter: DoctorsSearchPresentation {
    func doctorsRequest() {
        interactor.getDoctors()
    }

    func performQuery(with text: String, specialization: String?) {
        guard let doctors = view?.resultList else { return }

        let filteredDoctors = doctors.filter { doctor in
            if text.isEmpty { return true }
            let lowercasedFilter = text.lowercased()

            return doctor.fullName.lowercased().contains(lowercasedFilter)
        }

        guard let specialization = specialization else {
            view?.doctorsSnapshot(filteredDoctors)
            return
        }

        let specializationDoctors = filteredDoctors.filter { $0.specialization == specialization}

        view?.doctorsSnapshot(specializationDoctors)
    }

    func didFinish(with doctor: Doctor?) {
        didFinish?(doctor)
    }
}

// MARK: - DoctorsSearchInteractorDelegate

extension DoctorsSearchPresenter: DoctorsSearchInteractorDelegate {
    func doctorsDidRecieved(_ doctors: [Doctor]) {
        view?.resultList = doctors
        view?.doctorsSnapshot(doctors)
    }
}
