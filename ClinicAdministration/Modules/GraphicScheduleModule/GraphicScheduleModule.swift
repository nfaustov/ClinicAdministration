//
//  GraphicScheduleModule.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.04.2021.
//

import Foundation

protocol GraphicScheduleModule: AnyObject {
    var coordinator: CalendarSubscription? { get set }
    var didFinish: ((_ date: Date) -> Void)? { get set }
}

protocol GraphicScheduleView: BaseView {
    var date: Date! { get set }

    func updateTableView(with schedules: [DoctorSchedule])
    func calendarPicked(date: Date?)
}

protocol GraphicSchedulePresentation: AnyObject {
    func didSelected(date: Date)
    func pickDateInCalendar()
    func updateSchedule(_ schedule: DoctorSchedule)
    func didFinish(with date: Date)
}

protocol GraphicScheduleInteraction: BaseInteractor {
    func getSchedules(for date: Date)
    func updateSchedule(_ schedule: DoctorSchedule)
}

protocol GraphicScheduleInteractorDelegate: AnyObject {
    func schedulesDidRecieved(_ schedules: [DoctorSchedule])
}
