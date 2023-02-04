//
//  GraphicScheduleSubscription.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 21.04.2021.
//

import Foundation

protocol GraphicScheduleSubscription: AnyObject {
    func routeToGraphicSchedule(onDate: Date, didFinish: @escaping (Date?) -> Void)
}
