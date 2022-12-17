//
//  PatientCardViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 17.12.2022.
//

import UIKit

final class PatientCardViewController: UIViewController {
    typealias PresenterType = PatientCardPresentation
    var presenter: PresenterType!

    var patient: Patient!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - PatientCardView

extension PatientCardViewController: PatientCardView {
}
