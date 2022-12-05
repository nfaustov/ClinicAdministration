//
//  ScheduleModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 23.04.2021.
//

import Foundation

protocol ScheduleModule: AnyObject {
    var coordinator: (CalendarSubscription &
                      GraphicScheduleSubscription &
                      CreateScheduleSubscription &
                      DoctorsSearchSubscription &
                      SchedulesListSubscription &
                      PatientAppointmentSubscription)? { get set }
    var didFinish: ((_ date: Date) -> Void)? { get set }
}

protocol ScheduleView: View {
    var date: Date { get set }
    var selectedSchedule: DoctorSchedule? { get set }

    func daySnapshot(schedules: [DoctorSchedule], selectedSchedule: DoctorSchedule)
    func emptyDaySnapshot()
    func doctorSnapshot(schedule: DoctorSchedule)
    func changeDate(_ date: Date?)
    func noNextScheduleAlert()
}

protocol SchedulePresentation: AnyObject {
    func didSelected(_ schedule: DoctorSchedule)
    func didSelected(date: Date)
    func pickDateInCalendar()
    func addNewDoctorSchedule(onDate: Date)
    func createSchedule(for doctor: Doctor, onDate: Date)
    func removeDoctorSchedule(_ schedule: DoctorSchedule)
    func switchToGraphicScreen(onDate: Date)
    func showDoctorsNextSchedule(after currentSchedule: DoctorSchedule)
    func showSchedulesList(for doctor: Doctor)
    func registerPatient(schedule: DoctorSchedule, selectedAppointment: PatientAppointment)
    func showPatientCard(_ patient: Patient)
}

protocol ScheduleInteraction: Interactor {
    func getSchedules(for date: Date)
    func getDoctorsNextSchedule(after currentSchedule: DoctorSchedule)
    func deleteSchedule(_ schedule: DoctorSchedule)
}

protocol ScheduleInteractorDelegate: AnyObject {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule])
    func scheduleDidRecieved(_ schedule: DoctorSchedule?)
}
