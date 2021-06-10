//
//  Modules.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.04.2021.
//

import UIKit

protocol Modules {
    func timeTable(selectedSchedule: DoctorSchedule?) -> (UIViewController, TimeTableModule)
    func graphicTimeTable(_ date: Date) -> (UIViewController, GraphicTimeTableModule)
    func calendar() -> (UIViewController, CalendarModule)
    func createSchedule() -> (UIViewController, CreateScheduleModule)
    func doctorsSearch() -> (UIViewController, DoctorsSearchModule)
    func pickTimeInterval(availableOnDate: Date, selected: (Date, Date)?) -> (UIViewController, PickTimeIntervalModule)
    func pickCabinet(selected: Int?) -> (UIViewController, PickCabinetModule)
    func addSchedule(_ schedule: DoctorSchedule) -> (UIViewController, AddScheduleModule)
}
