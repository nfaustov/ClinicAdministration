//
//  GraphicTimeTableInteractorInput.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 13.04.2021.
//

import Foundation

protocol GraphicTimeTableInteractorInput: AnyObject {
    func getSchedules(for date: Date)
}
