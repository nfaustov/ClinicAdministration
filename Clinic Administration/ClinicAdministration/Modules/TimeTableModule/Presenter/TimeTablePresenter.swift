//
//  TimeTablePresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation

final class TimeTablePresenter<V, I>: PresenterInteractor<V, I>,
    TimeTableModule where V: TimeTableDisplaying, I: TimeTableInteraction {
    weak var coordinator: (CalendarSubscription & GraphicTimeTableSubscription & CreateScheduleSubscription)?

    var didFinish: ((Date) -> Void)?

    private func prepareIfNeeded(_ schedule: DoctorSchedule) -> DoctorSchedule {
        if schedule.patientAppointments.count % 2 != 0 {
            var preparedSchedule = schedule
            let cell = PatientAppointment(scheduledTime: nil, duration: 0, patient: nil)
            preparedSchedule.patientAppointments.append(cell)
            return preparedSchedule
        } else {
            return schedule
        }
    }
}

// MARK: - TimeTablePresentaion

extension TimeTablePresenter: TimeTablePresentation {
    func didSelected(_ schedule: DoctorSchedule) {
        view?.date = schedule.startingTime
        view?.doctorSnapshot(schedule: prepareIfNeeded(schedule))
    }

    func didSelected(patient: Patient) {
        // MARK: Present patient screen
    }

    func didSelected(date: Date) {
        interactor.getSchedules(for: date)
        view?.date = date
    }

    func pickDateInCalendar() {
        coordinator?.routeToCalendar { [weak self] date in
            self?.view?.sidePicked(date: date)
            if let date = date {
                self?.didSelected(date: date)
            }
        }
    }

    func addNewDoctorSchedule(onDate date: Date) {
        coordinator?.routeToCreateSchedule(date: date)
    }

    func removeDoctorSchedule(_ schedule: DoctorSchedule) {
    }

    func switchToGraphicScreen(onDate date: Date) {
        coordinator?.routeToGraphicTimeTable(onDate: date) { [weak self] selectedDate in
            if selectedDate != date {
                self?.view?.sidePicked(date: selectedDate)
                self?.didSelected(date: selectedDate ?? Date())
            }
        }
    }
}

// MARK: - TimeTableInteractorDelegate

extension TimeTablePresenter: TimeTableInteractorDelegate {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule]) {
        if let firstSchedule = schedules.first {
            var preparedSchedules = schedules
            preparedSchedules.remove(at: 0)
            preparedSchedules.insert(prepareIfNeeded(firstSchedule), at: 0)

            view?.daySnapshot(schedules: preparedSchedules)
        } else {
            view?.daySnapshot(schedules: [])
        }
    }
}
