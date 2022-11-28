//
//  TimeTablePresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation

final class TimeTablePresenter<V, I>: PresenterInteractor<V, I>,
                                      TimeTableModule where V: TimeTableDisplaying, I: TimeTableInteraction {
    weak var coordinator: (CalendarSubscription &
                           GraphicTimeTableSubscription &
                           CreateScheduleSubscription &
                           DoctorsSearchSubscription &
                           SchedulesListSubscription &
                           PatientAppointmentSubscription)?

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
            self.view?.changeDate(date)
        }
    }

    func addNewDoctorSchedule(onDate date: Date) {
        coordinator?.routeToDoctorsSearch(didFinish: { doctor in
            guard let doctor = doctor else { return }

            self.createSchedule(for: doctor, onDate: date)
        })
    }

    func createSchedule(for doctor: Doctor, onDate date: Date) {
        coordinator?.routeToCreateSchedule(for: doctor, onDate: date) { schedule in
            guard schedule != nil else { return }

            self.view?.selectedSchedule = schedule
        }
    }

    func removeDoctorSchedule(_ schedule: DoctorSchedule) {
        interactor.deleteSchedule(schedule)
        interactor.getSchedules(for: schedule.startingTime)
    }

    func switchToGraphicScreen(onDate date: Date) {
        coordinator?.routeToGraphicTimeTable(onDate: date) { selectedDate in
            self.view?.changeDate(selectedDate)
        }
    }

    func showDoctorsNextSchedule(after currentSchedule: DoctorSchedule) {
        interactor.getDoctorsNextSchedule(after: currentSchedule)
    }

    func showSchedulesList(for doctor: Doctor) {
        coordinator?.routeToSchedulesList(for: doctor) { schedule in
            guard let schedule = schedule else { return }

            self.view?.changeDate(schedule.startingTime)
            self.view?.doctorSnapshot(schedule: schedule)
        }
    }

    func createPatientAppointment(schedule: DoctorSchedule?, selectedAppointment: PatientAppointment) {
        guard let schedule = schedule else { return }

        coordinator?.routeToPatientAppointment(schedule: schedule, appointment: selectedAppointment) { _ in
        }
    }

    func showPatientCard(_ patient: Patient) {
    }
}

// MARK: - TimeTableInteractorDelegate

extension TimeTablePresenter: TimeTableInteractorDelegate {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule]) {
        if let firstSchedule = schedules.first {
            let scheduleIndex = schedules.firstIndex(of: view?.selectedSchedule ?? firstSchedule) ?? 0
            var preparedSchedules = schedules
            let preparedSchedule = prepareIfNeeded(schedules[scheduleIndex])
            preparedSchedules.remove(at: scheduleIndex)
            preparedSchedules.insert(preparedSchedule, at: scheduleIndex)
            view?.daySnapshot(schedules: preparedSchedules, selectedSchedule: preparedSchedule)
        } else {
            view?.emptyDaySnapshot()
        }
    }

    func scheduleDidRecieved(_ schedule: DoctorSchedule?) {
        if let schedule = schedule {
            view?.selectedSchedule = schedule
            view?.changeDate(schedule.startingTime)
            view?.doctorSnapshot(schedule: prepareIfNeeded(schedule))
        } else {
            view?.noNextScheduleAlert()
        }
    }
}
