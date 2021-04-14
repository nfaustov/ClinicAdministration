//
//  TimeTablePresentation.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation

protocol TimeTablePresentation: AnyObject {
    func didSelected(_ schedule: DoctorSchedule)

    func didSelected(date: Date)

    func calendarRequired()

    func addNewDoctorSchedule()

    func removeDoctorSchedule()

    func switchToGraphicScreen(onDate: Date)
}
