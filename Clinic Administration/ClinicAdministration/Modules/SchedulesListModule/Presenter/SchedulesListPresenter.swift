//
//  SchedulesListPresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 12.10.2021.
//

import Foundation

final class SchedulesListPresenter<V, I>: PresenterInteractor<V, I>, SchedulesListModule
where V: SchedulesListDisplaying, I: SchedulesListInteractor {
    var didFinish: ((DoctorSchedule) -> Void)?
}

// MARK: - SchedulesListPresentation

extension SchedulesListPresenter: SchedulesListPresentation {
    func didFinish(with schedule: DoctorSchedule) {
        didFinish?(schedule)
    }
}
