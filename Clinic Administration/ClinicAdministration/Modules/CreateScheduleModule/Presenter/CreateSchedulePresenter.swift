//
//  CreateSchedulePresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 27.04.2021.
//

import Foundation

final class CreateSchedulePresenter<V, I>: PresenterInteractor<V, I>, CreateScheduleModule
where V: CreateScheduleDisplaying, I: CreateScheduleInteraction {
    weak var coordinator: (CalendarSubscription &
                           PickTimeIntervalSubscription &
                           PickCabinetSubscription &
                           DoctorsSearchSubscription &
                           GraphicTimeTablePreviewSubscription)?

    var didFinish: ((DoctorSchedule?) -> Void)?
}

// MARK: - CreateSchedulePresentation

extension CreateSchedulePresenter: CreateSchedulePresentation {
    func pickDoctor() {
        coordinator?.routeToDoctorsSearch { doctor in
            guard let doctor = doctor else { return }

            self.view?.currentDoctor = doctor
        }
    }

    func pickDateInCalendar() {
        coordinator?.routeToCalendar { date in
            guard let date = date else { return }

            self.view?.date = date
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

    func schedulePreview(_ schedule: DoctorSchedule) {
        coordinator?.routeToGraphicTimeTablePreview(schedule) { editedSchedule in
            self.view?.pickedInterval((editedSchedule.startingTime, editedSchedule.endingTime))
        }
    }

    func createSchedule(_ schedule: DoctorSchedule) {
        interactor.createSchedule(schedule)
    }
}

// MARK: - CreateScheduleInteractorDelegate

extension CreateSchedulePresenter: CreateScheduleInteractorDelegate {
    func scheduleDidCreated(_ schedule: DoctorSchedule) {
        didFinish?(schedule)
    }
}
