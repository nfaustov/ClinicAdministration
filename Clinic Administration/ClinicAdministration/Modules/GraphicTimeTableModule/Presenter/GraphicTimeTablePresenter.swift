//
//  GraphicTimeTablePresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 13.04.2021.
//

import Foundation

final class GraphicTimeTablePresenter<V, I>: PresenterInteractor<V, I>,
                                             GraphicTimeTableModule where V: GraphicTimeTableDisplaying,
                                                                          I: GraphicTimeTableInteractor {
    weak var coordinator: CalendarSubscription?

    var didFinish: ((Date) -> Void)?
}

// MARK: - GraphicTimeTablePresentation

extension GraphicTimeTablePresenter: GraphicTimeTablePresentation {
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

    func scheduleDidUpdated(_ schedule: DoctorSchedule) {
        var updatedSchedule = schedule
        updatedSchedule.updateAppointments()
        interactor.updateSchedule(updatedSchedule)
    }
}

// MARK: - GraphicTimeTableInteractorDelegate

extension GraphicTimeTablePresenter: GraphicTimeTableInteractorDelegate {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule]) {
        view?.updateTableView(with: schedules)
    }
}
