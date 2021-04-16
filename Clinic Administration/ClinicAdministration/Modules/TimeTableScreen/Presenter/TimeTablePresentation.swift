//
//  TimeTablePresentation.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import UIKit

protocol TimeTablePresentation: AnyObject {
    func didSelected(_ schedule: DoctorSchedule)

    func didSelected(date: Date)

    func openCalendar(_ viewcontroller: UIViewController)

    func addNewDoctorSchedule()

    func removeDoctorSchedule()

    func switchToGraphicScreen(onDate: Date)
}
