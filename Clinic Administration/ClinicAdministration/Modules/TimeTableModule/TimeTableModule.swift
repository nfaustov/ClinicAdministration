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
                      DoctorsSearchSubscription)? { get set }
    var didFinish: ((_ date: Date) -> Void)? { get set }
}

protocol TimeTableDisplaying: View {
    var date: Date { get set }
    var newSchedule: DoctorSchedule? { get }

    func daySnapshot(schedules: [DoctorSchedule], selectedSchedule: DoctorSchedule)
    func emptyDaySnapshot()
    func doctorSnapshot(schedule: DoctorSchedule)
    func sidePicked(date: Date?)
}

protocol TimeTablePresentation: AnyObject {
    func didSelected(_ schedule: DoctorSchedule)
    func didSelected(date: Date)
    func pickDateInCalendar()
    func addNewDoctorSchedule(onDate: Date)
    func removeDoctorSchedule(_ schedule: DoctorSchedule)
    func switchToGraphicScreen(onDate: Date)
}

protocol TimeTableInteraction: Interactor {
    func getSchedules(for date: Date)
    func deleteSchedule(_ schedule: DoctorSchedule)
}

protocol TimeTableInteractorDelegate: AnyObject {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule])
}
