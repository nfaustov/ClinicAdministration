//
//  GraphicTimeTablePresentation.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 13.04.2021.
//

import Foundation

protocol GraphicTimeTablePresentation: AnyObject {
    func didSelected(date: Date)

    func calendarRequired()
}
