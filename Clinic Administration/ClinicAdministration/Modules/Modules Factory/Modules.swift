//
//  Modules.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.04.2021.
//

import UIKit

protocol Modules {
    func timeTable() -> (UIViewController, TimeTableModule)
    func graphicTimeTable(_ date: Date) -> (UIViewController, GraphicTimeTableModule)
    func calendar() -> (UIViewController, CalendarModule)
    func createSchedule(with date: Date) -> (UIViewController, CreateScheduleModule)
}
