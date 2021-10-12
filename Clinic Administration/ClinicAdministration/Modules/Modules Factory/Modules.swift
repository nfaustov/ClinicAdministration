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
    func createSchedule(for: Doctor, onDate: Date) -> (UIViewController, CreateScheduleModule)
    func doctorsSearch() -> (UIViewController, DoctorsSearchModule)
    func pickCabinet(selected: Int?) -> (UIViewController, PickCabinetModule)
    func graphicTimeTablePreview(_ schedule: DoctorSchedule) -> (UIViewController, GraphicTimeTablePreviewModule)
}
