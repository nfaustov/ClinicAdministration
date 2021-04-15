//
//  GraphicTimeTablePresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 13.04.2021.
//

import Foundation

final class GraphicTimeTablePresenter {
    weak var view: GraphicTimeTableDisplaying!
    var interactor: GraphicTimeTableInteractorInterface!
    var router: GraphicTimeTableRouting!

    init(
        view: GraphicTimeTableDisplaying,
        router: GraphicTimeTableRouting,
        interactor: GraphicTimeTableInteractorInterface
    ) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

// MARK: - GraphicTimeTablePresentation

extension GraphicTimeTablePresenter: GraphicTimeTablePresentation {
    func didSelected(date: Date) {
        interactor.getSchedules(for: date)
        if view.date == nil {
            view.date = date
        }
    }

    func calendarRequired() {
        router.routeToCalendarViewController()
    }
}

// MARK: - GraphicTimeTableInteractorOutput

extension GraphicTimeTablePresenter: GraphicTimeTableInteractorOutput {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule]) {
        view.updateTableView(with: schedules)
    }
}

// MARK: - GraphicTimeTableRouterOutput

extension GraphicTimeTablePresenter: GraphicTimeTableRouterOutput {
    func selectedDate(_ date: Date) {
        didSelected(date: date)
    }
}
