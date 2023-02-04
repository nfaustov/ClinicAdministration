//
//  GraphicSchedulePresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 13.04.2021.
//

import Foundation

final class GraphicSchedulePresenter<V, I>: PresenterInteractor<V, I>,
                                             GraphicScheduleModule where V: GraphicScheduleView,
                                                                          I: GraphicScheduleInteractor {
    weak var coordinator: CalendarSubscription?

    var didFinish: ((Date) -> Void)?
}

// MARK: - GraphicSchedulePresentation

extension GraphicSchedulePresenter: GraphicSchedulePresentation {
    func didFinish(with date: Date) {
        didFinish?(date)
    }

    func didSelected(date: Date) {
        interactor.getSchedules(for: date)
    }

    func pickDateInCalendar() {
        coordinator?.routeToCalendar { date in
            self.view?.calendarPicked(date: date)
        }
    }

    func updateSchedule(_ schedule: DoctorSchedule) {
        var updatedSchedule = schedule
        updatedSchedule.updateAppointments()
        interactor.updateSchedule(updatedSchedule)
    }
}

// MARK: - GraphicScheduleInteractorDelegate

extension GraphicSchedulePresenter: GraphicScheduleInteractorDelegate {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule]) {
        view?.updateTableView(with: schedules)
    }
}
