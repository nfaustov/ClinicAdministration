//
//  SchedulesListViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 12.10.2021.
//

import UIKit

final class SchedulesListViewController: UIViewController {
    typealias PresenterType = SchedulesListPresentation
    var presenter: PresenterType!

    var doctor: Doctor!
}

// MARK: - SchedulesListDisplaying

extension SchedulesListViewController: SchedulesListDisplaying {
}
