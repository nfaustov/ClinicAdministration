//
//  GraphicSchedulesPresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.05.2021.
//

import Foundation

final class GraphicSchedulesPresenter<V, I>: PresenterInteractor<V, I>,
                                             GraphicSchedulesModule where V: GraphicSchedulesDisplaying,
                                                                          I: GraphicSchedulesInteractor {
    var didFinish: ((DoctorSchedule?) -> Void)?
}

// MARK: - GraphicSchedulesPresentation

extension GraphicSchedulesPresenter: GraphicSchedulesPresentation {
    func didFinish(with schedule: DoctorSchedule) {
        didFinish?(schedule)
    }

    func didSelected(date: Date) {
        interactor.getSchedules(for: date)
    }
}

// MARK: - GraphicSchedulesInteractorDelegate

extension GraphicSchedulesPresenter: GraphicSchedulesInteractorDelegate {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule]) {
        view?.applySchedules(schedules)
    }
}
