//
//  GraphicTimeTablePresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 13.04.2021.
//

import Foundation

final class GraphicTimeTablePresenter<V, I>: PresenterInteractor<V, I>,
    GraphicTimeTableModule where V: GraphicTimeTableDisplaying, I: GraphicTimeTableInteractor {
    weak var coordinator: TimeTableCoordinator?

    var didFinish: ((Date) -> Void)?
}

// MARK: - GraphicTimeTablePresentation

extension GraphicTimeTablePresenter: GraphicTimeTablePresentation {
    func didFinish(with date: Date) {
        didFinish?(date)
    }

    func didSelected(date: Date) {
        interactor.getSchedules(for: date)
        if view?.date == nil {
            view?.date = date
        }
    }

    func pickDateInCalendar() {
        coordinator?.routeToCalendar { [weak self] date in
            self?.view?.calendarPicked(date: date)
            if let date = date {
                self?.didSelected(date: date)
            }
        }
    }
}

// MARK: - GraphicTimeTableInteractorDelegate

extension GraphicTimeTablePresenter: GraphicTimeTableInteractorDelegate {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule]) {
        view?.updateTableView(with: schedules)
    }
}
