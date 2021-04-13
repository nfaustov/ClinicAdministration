//
//  DoctorSectionPlaceholder.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 12.04.2021.
//

import UIKit

struct DoctorSectionPlaceholder: Hashable {
    var message: String
    var buttonTitle: String

    static let addFirstSchedule = DoctorSectionPlaceholder(
        message: "НА ЭТОТ ДЕНЬ НЕТ РАСПИСАНИЙ ВРАЧЕЙ",
        buttonTitle: "СОЗДАТЬ РАСПИСАНИЕ"
    )
}
