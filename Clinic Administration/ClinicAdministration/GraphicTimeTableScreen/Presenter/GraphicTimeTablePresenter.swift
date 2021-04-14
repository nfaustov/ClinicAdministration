//
//  GraphicTimeTablePresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 13.04.2021.
//

import Foundation

final class GraphicTimeTablePresenter {
    weak var view: GraphicTimeTableDisplaying!
    var interactor: GraphicTimeTableInteractorInput!
    var router: GraphicTimeTableRouting!

    init(
        view: GraphicTimeTableDisplaying,
        router: GraphicTimeTableRouting,
        interactor: GraphicTimeTableInteractorInput
    ) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

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

extension GraphicTimeTablePresenter: GraphicTimeTableInteractorOutput {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule]) {
        view.updateTableView(with: schedules)
    }
}

extension GraphicTimeTablePresenter: GraphicTimeTableRouterOutput {
    func selectedDate(_ date: Date) {
        didSelected(date: date)
    }
}
