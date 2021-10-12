//
//  CreateScheduleSubscription.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 27.04.2021.
//

import Foundation

protocol CreateScheduleSubscription: AnyObject {
    func routeToCreateSchedule(for: Doctor, onDate: Date, didFinish: @escaping (DoctorSchedule?) -> Void)
}
