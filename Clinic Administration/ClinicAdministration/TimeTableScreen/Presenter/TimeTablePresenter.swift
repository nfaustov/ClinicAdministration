//
//  TimeTablePresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation

final class TimeTablePresenter {
    weak var view: TimeTableDisplaying!
    var interactor: TimeTableInteractorInput!
    var router: TimeTableRouterInput!

    init(view: TimeTableDisplaying, router: TimeTableRouterInput, interactor: TimeTableInteractorInput) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension TimeTablePresenter: TimeTablePresentation {
    func viewDidLoad(with date: Date) {
        interactor.getSchedules(for: date)
    }

    func didSelected(_ schedule: DoctorSchedule) {
        view.updatePatientsSection(for: prepareIfNeeded(schedule))
    }

    func didSelected(date: Date) {
    }

    func didSelected(patient: TimeTablePatient) {
        // MARK: Present patient screen
    }

    func calendarRequired() {
    }

    func addNewDoctorSchedule() {
    }

    func removeDoctorSchedule() {
    }

    func switchToGraphicScreen(with date: Date) {
        router.routeToGraphicTimeTableScreen(onDate: date)
    }
}

extension TimeTablePresenter: TimeTableInteractorOutput {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule]) {
        guard let firstSchedule = schedules.first else { return }

        var preparedSchedules = schedules
        preparedSchedules.remove(at: 0)
        preparedSchedules.insert(prepareIfNeeded(firstSchedule), at: 0)
        view.applyInitialSnapshot(ofSchedules: preparedSchedules)
    }
}

private extension TimeTablePresenter {
    func prepareIfNeeded(_ schedule: DoctorSchedule) -> DoctorSchedule {
        if schedule.patientCells.count % 2 != 0 {
            var preparedSchedule = schedule
            let cell = TimeTablePatientCell(scheduledTime: nil, duration: 0, patient: nil)
            preparedSchedule.patientCells.append(cell)
            return preparedSchedule
        } else {
            return schedule
        }
    }
}
