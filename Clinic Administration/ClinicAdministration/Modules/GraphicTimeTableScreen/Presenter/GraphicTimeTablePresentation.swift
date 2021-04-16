//
//  GraphicTimeTablePresentation.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 13.04.2021.
//

import UIKit

protocol GraphicTimeTablePresentation: AnyObject {
    func didSelected(date: Date)

    func calendarRequired(_ viewController: UIViewController)
}
