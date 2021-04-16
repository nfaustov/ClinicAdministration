//
//  TimeTableRouting.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import UIKit

protocol TimeTableRouting: AnyObject {
    func routeToGraphicTimeTableScreen(onDate: Date)

    func routeToCalendar(_ calendarViewController: UIViewController)
}
