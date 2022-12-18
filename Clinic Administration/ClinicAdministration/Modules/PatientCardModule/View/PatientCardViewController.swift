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

    private let patientDataInput = PatientDataView()

    var patient: Patient!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Design.Color.lightGray
    }

    private func configureHierarchy() {
        let passportButton = PassportButtonView()
    }

    @objc private func passportData() {
    }

    @objc private func newCheck() {
    }
}

// MARK: - PatientCardView

extension PatientCardViewController: PatientCardView {
}
