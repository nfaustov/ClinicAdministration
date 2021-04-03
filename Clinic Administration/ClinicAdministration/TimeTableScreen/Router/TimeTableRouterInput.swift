//
//  TimeTableRouterInput.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation

protocol TimeTableRouterInput: AnyObject {
    func routeToGraphicTimeTableScreen(onDate: Date)
}
