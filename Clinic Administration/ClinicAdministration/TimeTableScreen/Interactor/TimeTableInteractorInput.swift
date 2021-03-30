//
//  TimeTableInteractorInput.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import Foundation

protocol TimeTableInteractorInput: AnyObject {
    func getSchedules(for date: Date)
}
