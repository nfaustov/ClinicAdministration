//
//  TimeTablePresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import UIKit

final class TimeTablePresenter {
    weak var view: TimeTableDisplaying!
    var interactor: TimeTableInteractorInterface!
    var router: TimeTableRouting!

    init(view: TimeTableDisplaying, router: TimeTableRouting, interactor: TimeTableInteractorInterface) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

    private func prepareIfNeeded(_ schedule: DoctorSchedule) -> DoctorSchedule {
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

// MARK: - TimeTablePresentaion

extension TimeTablePresenter: TimeTablePresentation {
    func didSelected(_ schedule: DoctorSchedule) {
        view.date = schedule.startingTime
        view.doctorSnapshot(schedule: prepareIfNeeded(schedule))
    }

    func didSelected(patient: TimeTablePatient) {
        // MARK: Present patient screen
    }

    func didSelected(date: Date) {
        interactor.getSchedules(for: date)
        view.date = date
    }

    func openCalendar(_ viewController: UIViewController) {
        router.routeToCalendar(viewController)
    }

    func addNewDoctorSchedule() {
    }

    func removeDoctorSchedule() {
    }

    func switchToGraphicScreen(onDate date: Date) {
        router.routeToGraphicTimeTableScreen(onDate: date)
    }
}

// MARK: - TimeTableInteractorOutput

extension TimeTablePresenter: TimeTableInteractorOutput {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule]) {
        if let firstSchedule = schedules.first {
            var preparedSchedules = schedules
            preparedSchedules.remove(at: 0)
            preparedSchedules.insert(prepareIfNeeded(firstSchedule), at: 0)

            view.daySnapshot(schedules: preparedSchedules)
        } else {
            view.daySnapshot(schedules: [])
        }
    }
}