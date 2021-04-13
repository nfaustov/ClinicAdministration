//
//  TimeTableRouterInput.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation

protocol TimeTableRouting: AnyObject {
    func routeToGraphicTimeTableScreen(onDate: Date)

    func routeToCalendarViewController()
}
