//
//  TimeTableViewOutput.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation

protocol TimeTableViewOutput: AnyObject {
    func viewDidLoad(with date: Date)

    func didSelected(_ schedule: DoctorSchedule)

    func didSelected(date: Date)

    func calendarRequired()
}
