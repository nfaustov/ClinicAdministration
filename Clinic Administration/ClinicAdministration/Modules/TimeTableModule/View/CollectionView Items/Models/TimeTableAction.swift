//
//  TimeTableAction.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 06.04.2021.
//

import UIKit

struct TimeTableAction: Hashable {
    let name: String
    let icon: UIImage?

    static let showNextSchedule = TimeTableAction(
        name: "Ближайшее расписание",
        icon: UIImage(named: "chevron_right")
    )
    static let showAllSchedules = TimeTableAction(
        name: "Показать все расписания",
        icon: UIImage(named: "chevron_right")
    )
    static let editSchedule = TimeTableAction(
        name: "Редактировать расписание",
        icon: UIImage(named: "chevron_right")
    )
}
