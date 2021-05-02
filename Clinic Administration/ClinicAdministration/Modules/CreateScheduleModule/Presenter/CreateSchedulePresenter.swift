//
//  CreateSchedulePresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 27.04.2021.
//

import Foundation

final class CreateSchedulePresenter<V, I>: PresenterInteractor<V, I>,
                                           CreateScheduleModule where V: CreateScheduleDisplaying,
                                                                      I: CreateScheduleInteraction {
    weak var coordinator: (CalendarSubscription &
                           PickDoctorSubscription &
                           PickTimeIntervalSubscription &
                           PickCabinetSubscription)?

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

    func pickDoctor(selected: Doctor?) {
        coordinator?.routeToPickDoctor(previouslyPicked: selected) { doctor in
            guard let doctor = doctor else { return }

            self.view?.pickedDoctor(doctor)
        }
    }

    func pickTimeInterval(availableOnDate date: Date, selected: (Date, Date)?) {
        coordinator?.routeToPickTimeInterval(date: date, previouslyPicked: selected) { starting, ending in
            guard let starting = starting,
                  let ending = ending else { return }

            self.view?.pickedInterval((starting, ending))
        }
    }

    func pickCabinet(selected: Int?) {
        coordinator?.routeToPickCabinet(previouslyPicked: selected) { cabinet in
            guard let cabinet = cabinet else { return }

            self.view?.pickedCabinet(cabinet)
        }
    }
}

// MARK: - CreateScheduleInteractorDelegate

extension CreateSchedulePresenter: CreateScheduleInteractorDelegate {
}
