//
//  ScheduleAction.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 06.04.2021.
//

import UIKit

struct ScheduleAction: Hashable {
    let name: String
    let icon: UIImage?

    static let showNextSchedule = ScheduleAction(
        name: "Ближайшее расписание",
        icon: UIImage(named: "chevron_right")
    )
    static let showAllSchedules = ScheduleAction(
        name: "Показать все расписания",
        icon: UIImage(named: "chevron_right")
    )
    static let editSchedule = ScheduleAction(
        name: "Редактировать расписание",
        icon: UIImage(named: "chevron_right")
    )
}
