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
    weak var coordinator: ScheduleCoordinator?
}

// MARK: - PatientCardPresentation

extension PatientCardPresenter: PatientCardPresentation {
}

// MARK: - PatientCardInteractorDelegate

extension PatientCardPresenter: PatientCardInteractorDelegate {
}
