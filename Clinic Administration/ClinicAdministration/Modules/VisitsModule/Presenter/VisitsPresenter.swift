//
//  VisitsPresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 21.12.2022.
//

import Foundation

final class VisitsPresenter<V, I>: PresenterInteractor<V, I>,
                                   VisitsModule where V: VisitsView,
                                                      I: VisitsInteractor {
    weak var coordinator: ScheduleCoordinator?
}

// MARK: - VIsitsPresentaion

extension VisitsPresenter: VisitsPresentation {
    func showVisit(_ visit: Visit) {
    }
}

// MARK: - VisitsInteractorDelegate

extension VisitsPresenter: VisitsInteractorDelegate {
}
