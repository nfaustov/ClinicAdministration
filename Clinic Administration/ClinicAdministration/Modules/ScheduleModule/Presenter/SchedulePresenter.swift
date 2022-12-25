//
//  SchedulePresenter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation

final class SchedulePresenter<V, I>: PresenterInteractor<V, I>,
                                     ScheduleModule where V: ScheduleView, I: ScheduleInteraction {
    weak var coordinator: (CalendarSubscription &
                           GraphicScheduleSubscription &
                           CreateScheduleSubscription &
                           DoctorsSearchSubscription &
                           SchedulesListSubscription &
                           PatientAppointmentSubscription)?

    var didFinish: ((Date) -> Void)?

    private func prepareIfNeeded(_ schedule: DoctorSchedule) -> DoctorSchedule {
        if schedule.patientAppointments.count % 2 != 0 {
            var preparedSchedule = schedule
            let cell = PatientAppointment(scheduledTime: Date(), duration: 0, patient: nil)
            preparedSchedule.patientAppointments.append(cell)
            return preparedSchedule
        } else {
            return schedule
        }
    }
}

// MARK: - SchedulePresentaion

extension SchedulePresenter: SchedulePresentation {
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
    }

    func switchToGraphicScreen(onDate date: Date) {
        coordinator?.routeToGraphicSchedule(onDate: date) { selectedDate in
            self.view?.changeDate(selectedDate)
        }
    }

    func showDoctorsNextSchedule(after currentSchedule: DoctorSchedule) {
        interactor.getDoctorsNextSchedule(after: currentSchedule)
    }

    func showSchedulesList(for doctor: Doctor) {
        coordinator?.routeToSchedulesList(for: doctor) { schedule in
            self.scheduleDidRecieved(schedule)
        }
    }

    func registerPatient(schedule: DoctorSchedule, selectedAppointment: PatientAppointment) {
        coordinator?.routeToPatientAppointment(schedule: schedule, appointment: selectedAppointment) { editedSchedule in
            self.view?.selectedSchedule = editedSchedule
        }
    }

    func showPatientCard(_ patient: Patient) {
    }
}

// MARK: - ScheduleInteractorDelegate

extension SchedulePresenter: ScheduleInteractorDelegate {
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
