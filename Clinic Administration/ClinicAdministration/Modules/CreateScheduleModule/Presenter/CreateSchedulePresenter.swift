//
//  CreateSchedulePresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 27.04.2021.
//

import Foundation

final class CreateSchedulePresenter<V, I>: PresenterInteractor<V, I>,
    CreateScheduleModule where V: CreateScheduleDisplaying, I: CreateScheduleInteraction {
    weak var coordinator: (CalendarSubscription & PickDoctorSubscription)?

    var didFinish: (() -> Void)?
}

// MARK: - CreateSchedulePresentation

extension CreateSchedulePresenter: CreateSchedulePresentation {
    func pickDateInCalendar() {
        coordinator?.routeToCalendar { date in
            guard let date = date else { return }

            self.view?.date = date
        }
    }

    func pickDoctor() {
        coordinator?.routeToPickDoctor()
    }
}

// MARK: - CreateScheduleInteractorDelegate

extension CreateSchedulePresenter: CreateScheduleInteractorDelegate {
}
