//
//  GraphicTimeTableSubscription.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 21.04.2021.
//

import Foundation

protocol GraphicTimeTableSubscription: AnyObject {
    func routeToGraphicTimeTable(onDate: Date, didFinish: @escaping (Date?) -> Void)
}
