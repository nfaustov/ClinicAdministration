//
//  GraphicScheudulesSubscription.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.05.2021.
//

import Foundation

protocol GraphicSchedulesSubscription: AnyObject {
    func routeToGraphicSchedules(onDate: Date, didFinish: @escaping ((DoctorSchedule?) -> Void))
}
