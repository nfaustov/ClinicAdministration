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

        configureHierarchy()

        patientDataInput.inputData(with: patient)
    }

    private func configureHierarchy() {
        let passportButton = PassportButtonView()
        let passportButtonTap = UITapGestureRecognizer(target: self, action: #selector(passportData))
        passportButton.addGestureRecognizer(passportButtonTap)

        let image = UIImage(named: "chevron_right")?.withTintColor(Design.Color.white)
        let checkButton = CheckButton(title: "Новый счет", image: image)
        let checkButtonTap = UITapGestureRecognizer(target: self, action: #selector(newCheck))
        checkButton.addGestureRecognizer(checkButtonTap)

        let visits = [
            Visit(
                registrationDate: Date(),
                visitDate: Date(),
                doctorsConclusion: nil,
                contract: nil
            ),
            Visit(
                registrationDate: Date().addingTimeInterval(86_400),
                visitDate: Date().addingTimeInterval(86_400),
                doctorsConclusion: nil,
                contract: nil
            ),
            Visit(
                registrationDate: Date().addingTimeInterval(172_800),
                visitDate: Date().addingTimeInterval(172_800),
                doctorsConclusion: nil,
                contract: nil
            )
        ]
        let visitsHistoryView = VisitsHistoryView(visits: visits)

        for subview in [patientDataInput, passportButton, checkButton, visitsHistoryView] {
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            patientDataInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            patientDataInput.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            patientDataInput.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            patientDataInput.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

            passportButton.topAnchor.constraint(equalTo: patientDataInput.bottomAnchor, constant: 30),
            passportButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passportButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            passportButton.heightAnchor.constraint(equalToConstant: 50),

            checkButton.topAnchor.constraint(equalTo: passportButton.bottomAnchor, constant: 20),
            checkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            checkButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65),
            checkButton.heightAnchor.constraint(equalToConstant: 50),

            visitsHistoryView.topAnchor.constraint(equalTo: checkButton.bottomAnchor, constant: 35),
            visitsHistoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visitsHistoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visitsHistoryView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func passportData() {
        presenter.showPassportData(for: patient)
    }

    @objc private func newCheck() {
        presenter.createCheck(for: patient)
    }
}

// MARK: - PatientCardView

extension PatientCardViewController: PatientCardView {
}
