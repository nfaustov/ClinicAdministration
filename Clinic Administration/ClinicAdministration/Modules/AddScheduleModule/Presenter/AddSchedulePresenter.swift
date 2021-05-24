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
    var didFinish: (() -> Void)?
}

// MARK: - AddSchedulePresentation

extension AddSchedulePresenter: AddSchedulePresentation {
    func addSchedule(_ schedule: DoctorSchedule) {
        interactor.addSchedule(schedule)
        didFinish?()
    }

    func updateNewSchedule(_ schedule: DoctorSchedule) {
        view?.newSchedule.startingTime = schedule.startingTime
        view?.newSchedule.endingTime = schedule.endingTime
    }

    func scheduleDidUpdated(_ schedule: DoctorSchedule) {
        var updatedSchedule = schedule
        updatedSchedule.updateAppointments()
        interactor.updateSchedule(updatedSchedule)
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
