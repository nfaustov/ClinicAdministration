//
//  GraphicTimeTableDisplaying.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 13.04.2021.
//

import Foundation

protocol GraphicTimeTableDisplaying: AnyObject {
    var date: Date! { get set }

    func updateTableView(with schedules: [DoctorSchedule])
}
