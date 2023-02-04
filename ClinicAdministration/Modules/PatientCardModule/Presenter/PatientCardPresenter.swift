//
//  PatientCardPresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 17.12.2022.
//

import Foundation

final class PatientCardPresenter<V, I>: PresenterInteractor<V, I>,
                                        PatientCardModule where V: PatientCardView,
                                                                I: PatientCardInteractor {
    weak var coordinator: PatientCoordinator?
}

// MARK: - PatientCardPresentation

extension PatientCardPresenter: PatientCardPresentation {
    func showPassportData(for: Patient) {
    }

    func createCheck(for: Patient) {
    }
}

// MARK: - PatientCardInteractorDelegate

extension PatientCardPresenter: PatientCardInteractorDelegate {
}
