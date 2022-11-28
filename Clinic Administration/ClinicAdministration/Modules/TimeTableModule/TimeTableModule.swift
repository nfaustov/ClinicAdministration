//
//  TimeTableModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 23.04.2021.
//

import Foundation

protocol TimeTableModule: AnyObject {
    var coordinator: (CalendarSubscription &
                      GraphicTimeTableSubscription &
                      CreateScheduleSubscription &
                      DoctorsSearchSubscription &
                      SchedulesListSubscription &
                      PatientAppointmentSubscription)? { get set }
    var didFinish: ((_ date: Date) -> Void)? { get set }
}

protocol TimeTableDisplaying: View {
    var date: Date { get set }
    var selectedSchedule: DoctorSchedule? { get set }

    func daySnapshot(schedules: [DoctorSchedule], selectedSchedule: DoctorSchedule)
    func emptyDaySnapshot()
    func doctorSnapshot(schedule: DoctorSchedule)
    func changeDate(_ date: Date?)
    func noNextScheduleAlert()
}

protocol TimeTablePresentation: AnyObject {
    func didSelected(_ schedule: DoctorSchedule)
    func didSelected(date: Date)
    func pickDateInCalendar()
    func addNewDoctorSchedule(onDate: Date)
    func createSchedule(for doctor: Doctor, onDate: Date)
    func removeDoctorSchedule(_ schedule: DoctorSchedule)
    func switchToGraphicScreen(onDate: Date)
    func showDoctorsNextSchedule(after currentSchedule: DoctorSchedule)
    func showSchedulesList(for doctor: Doctor)
    func createPatientAppointment(schedule: DoctorSchedule?, selectedAppointment: PatientAppointment)
    func showPatientCard(_ patient: Patient)
}

protocol TimeTableInteraction: Interactor {
    func getSchedules(for date: Date)
    func getDoctorsNextSchedule(after currentSchedule: DoctorSchedule)
    func deleteSchedule(_ schedule: DoctorSchedule)
}

protocol TimeTableInteractorDelegate: AnyObject {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule])
    func scheduleDidRecieved(_ schedule: DoctorSchedule?)
}
