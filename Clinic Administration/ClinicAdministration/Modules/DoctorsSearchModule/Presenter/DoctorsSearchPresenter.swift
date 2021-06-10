//
//  DoctorsSearchPresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 03.06.2021.
//

import Foundation

final class DoctorsSearchPresenter<V, I>: PresenterInteractor<V, I>,
                                          DoctorsSearchModule where V: DoctorsSearchDisplaying,
                                                                    I: DoctorsSearchInteraction {
    var didFinish: ((Doctor?) -> Void)?
}

// MARK: - DoctorsSearchPresentation

extension DoctorsSearchPresenter: DoctorsSearchPresentation {
    func doctorsRequest() {
        interactor.getDoctors()
    }

    func performQuery(with filter: String) {
        guard let doctors = view?.doctorsList else { return }

        let filteredDoctors = doctors.filter { doctor in
            if filter.isEmpty { return true }
            let lowercasedFilter = filter.lowercased()

            return doctor.fullName.lowercased().contains(lowercasedFilter)
        }

        view?.doctorsSnapshot(filteredDoctors)
    }

    func didFinish(with doctor: Doctor?) {
        didFinish?(doctor)
    }
}

// MARK: - DoctorsSearchInteractorDelegate

extension DoctorsSearchPresenter: DoctorsSearchInteractorDelegate {
    func doctorsDidRecieved(_ doctors: [Doctor]) {
        view?.doctorsList = doctors
        view?.doctorsSnapshot(doctors)
    }
}
