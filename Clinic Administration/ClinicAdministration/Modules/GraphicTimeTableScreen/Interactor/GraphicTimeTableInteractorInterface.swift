//
//  GraphicTimeTableInteractorInterface.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 13.04.2021.
//

import Foundation

protocol GraphicTimeTableInteractorInterface: AnyObject {
    func getSchedules(for date: Date)
}
