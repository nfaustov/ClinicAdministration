//
//  DoctorSectionPlaceholder.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 12.04.2021.
//

import UIKit

struct DoctorSectionPlaceholder: Hashable {
    var message: String
    var buttonTitle: String
    var target: UIViewController
    var action: Selector
}
