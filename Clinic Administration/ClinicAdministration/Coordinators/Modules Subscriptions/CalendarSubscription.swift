//
//  CalendarSubscription.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 21.04.2021.
//

import Foundation

protocol CalendarSubscription: AnyObject {
    func routeToCalendar(didFinish: @escaping (Date?) -> Void)
}
