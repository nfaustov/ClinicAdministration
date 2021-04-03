//
//  TimeTablePresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation

final class TimeTablePresenter {
    weak var view: TimeTableViewInput!
    var interactor: TimeTableInteractorInput!
    var router: TimeTableRouterInput!

    init(view: TimeTableViewInput, router: TimeTableRouterInput, interactor: TimeTableInteractorInput) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

    func didSelected(patient: TimeTablePatient) {
        // MARK: Present patient screen
    }
}

extension TimeTablePresenter: TimeTableViewOutput {
    func viewDidLoad(with date: Date) {
        interactor.getSchedules(for: date)
    }

    func didSelected(_ schedule: DoctorSchedule) {
        view.updatePatientsSection(for: schedule)
    }

    func didSelected(date: Date) {
    }

    func calendarRequired() {
    }
}

extension TimeTablePresenter: TimeTableInteractorOutput {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule]) {
        view.applyInitialSnapshot(ofSchedules: schedules)
    }
}
