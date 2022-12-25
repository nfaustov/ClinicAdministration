//
//  GraphicTimeTablePreviewPresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.05.2021.
//

import Foundation

final class GraphicTimeTablePreviewPresenter<V, I>: PresenterInteractor<V, I>, GraphicTimeTablePreviewModule
where V: GraphicTimeTablePreviewView, I: GraphicTimeTablePreviewInteractor {
    var didFinish: ((DoctorSchedule) -> Void)?
}

// MARK: - GraphicTimeTablePreviewPresentation

extension GraphicTimeTablePreviewPresenter: GraphicTimeTablePreviewPresentation {
    func didFinish(with schedule: DoctorSchedule) {
        var newSchedule = schedule
        newSchedule.updateAppointments()
        interactor.createSchedule(newSchedule)
    }

    func updateNewSchedule(_ schedule: DoctorSchedule) {
        view?.newSchedule.starting = schedule.starting
        view?.newSchedule.ending = schedule.ending
    }

    func updateSchedule(_ schedule: DoctorSchedule) {
        var updatedSchedule = schedule
        updatedSchedule.updateAppointments()
        interactor.updateSchedule(updatedSchedule)
    }

    func didSelected(date: Date) {
        interactor.getSchedules(for: date)
    }
}

// MARK: - GraphicTimeTablePreviewInteractorDelegate

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
