//
//  SchedulesListSubscription.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 12.10.2021.
//

import Foundation

protocol SchedulesListSubscription: AnyObject {
    func routeToSchedulesList(for doctor: Doctor, didFinish: @escaping (DoctorSchedule) -> Void)
}
