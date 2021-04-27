//
//  DoctorControl.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 26.04.2021.
//

import UIKit

struct DoctorControl: Hashable {
    var target: UIViewController
    var addAction: Selector
    var deleteAction: Selector
}
