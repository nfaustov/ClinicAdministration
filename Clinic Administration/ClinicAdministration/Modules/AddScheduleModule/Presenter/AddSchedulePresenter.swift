//
//  AddSchedulePresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.05.2021.
//

import Foundation

final class AddSchedulePresenter<V, I>: PresenterInteractor<V, I>,
                                             AddScheduleModule where V: AddScheduleDisplaying,
                                                                          I: AddScheduleInteractor {
    var didFinish: ((DoctorSchedule?) -> Void)?
}

// MARK: - AddSchedulePresentation

extension AddSchedulePresenter: AddSchedulePresentation {
    func didFinish(with schedule: DoctorSchedule?) {
        didFinish?(schedule)
    }

    func didSelected(date: Date) {
        interactor.getSchedules(for: date)
    }
}

// MARK: - AddScheduleInteractorDelegate

extension AddSchedulePresenter: AddScheduleInteractorDelegate {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule]) {
        guard let newSchedule = view?.newSchedule else { return }

        var updatedSchedules = schedules
        updatedSchedules.append(newSchedule)

        view?.applySchedules(updatedSchedules)
    }
}
