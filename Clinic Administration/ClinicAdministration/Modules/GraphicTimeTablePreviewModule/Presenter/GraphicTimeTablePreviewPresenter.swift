//
//  GraphicTimeTablePreviewPresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.05.2021.
//

import Foundation

final class GraphicTimeTablePreviewPresenter<V, I>: PresenterInteractor<V, I>, GraphicTimeTablePreviewModule
where V: GraphicTimeTablePreviewDisplaying, I: GraphicTimeTablePreviewInteractor {
    var didFinish: ((DoctorSchedule) -> Void)?
}

// MARK: - AddSchedulePresentation

extension GraphicTimeTablePreviewPresenter: GraphicTimeTablePreviewPresentation {
    func didFinish(with schedule: DoctorSchedule) {
        var newSchedule = schedule
        newSchedule.updateAppointments()
        interactor.createSchedule(newSchedule)
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

extension GraphicTimeTablePreviewPresenter: GraphicTimeTablePreviewInteractorDelegate {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule]) {
        guard let newSchedule = view?.newSchedule else { return }

        var updatedSchedules = schedules
        updatedSchedules.append(newSchedule)
        view?.applySchedules(updatedSchedules)
    }

    func scheduleDidCreated(_ schedule: DoctorSchedule) {
        didFinish?(schedule)
    }
}
