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
        coordinator?.routeToCalendar { date in
            self.view?.sidePicked(date: date)
        }
    }

    func addNewDoctorSchedule(onDate date: Date) {
        coordinator?.routeToCreateSchedule()
    }

    func removeDoctorSchedule(_ schedule: DoctorSchedule) {
        interactor.deleteSchedule(schedule)
        interactor.getSchedules(for: schedule.startingTime)
    }

    func switchToGraphicScreen(onDate date: Date) {
        coordinator?.routeToGraphicTimeTable(onDate: date) { selectedDate in
            self.view?.sidePicked(date: selectedDate)
        }
    }
}

// MARK: - TimeTableInteractorDelegate

extension TimeTablePresenter: TimeTableInteractorDelegate {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule]) {
        if let firstSchedule = schedules.first,
           let scheduleIndex = schedules.firstIndex(of: view?.newSchedule ?? firstSchedule) {
            var preparedSchedules = schedules
            let preparedSchedule = prepareIfNeeded(schedules[scheduleIndex])
            preparedSchedules.remove(at: scheduleIndex)
            preparedSchedules.insert(preparedSchedule, at: scheduleIndex)
            view?.daySnapshot(schedules: preparedSchedules, selectedSchedule: preparedSchedule)
        } else {
            view?.emptyDaySnapshot()
        }
    }
}
