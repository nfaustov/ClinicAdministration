//
//  AddScheduleSubscription.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.05.2021.
//

import Foundation

protocol AddScheduleSubscription: AnyObject {
    func routeToAddSchedule(_ schedule: DoctorSchedule, didFinish: @escaping ((DoctorSchedule?) -> Void))
}
