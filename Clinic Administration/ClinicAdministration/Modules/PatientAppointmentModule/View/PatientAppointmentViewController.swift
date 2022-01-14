//
//  PatientAppointmentViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 14.11.2021.
//

import UIKit

final class PatientAppointmentViewController: UIViewController {
    typealias PresenterType = PatientAppointmentPresentation
    var presenter: PresenterType!

    private let patientDataInput = PatientDataView()
    private let buttonView = UIView()
    private let button = UIButton(type: .custom)
    private let bottomView = UIView()

    private var appointmentView: PatientAppointmentDataView!

    private var patientDataInputTopConstraint = NSLayoutConstraint()

    var schedule: DoctorSchedule!
    var appointment: PatientAppointment!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Design.Color.lightGray

        configureHierarchy()
        configureNotifications()
    }

    private func configureHierarchy() {
        appointmentView = PatientAppointmentDataView(
            doctor: schedule.doctor,
            date: schedule.startingTime,
            scheduledTime: appointment.scheduledTime ?? Date()
        )
        appointmentView.layer.cornerRadius = Design.CornerRadius.large
        appointmentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(appointmentView)
        appointmentView.translatesAutoresizingMaskIntoConstraints = false

        patientDataInput.backgroundColor = Design.Color.white
        view.addSubview(patientDataInput)
        patientDataInput.translatesAutoresizingMaskIntoConstraints = false

        buttonView.backgroundColor = Design.Color.white
        button.backgroundColor = Design.Color.red
        button.setTitle("ЗАПИСАТЬ", for: .normal)
        button.setTitleColor(Design.Color.white, for: .normal)
        button.layer.cornerRadius = Design.CornerRadius.medium
        button.addTarget(self, action: #selector(addPatient), for: .touchUpInside)
        buttonView.addSubview(button)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonView)
        button.translatesAutoresizingMaskIntoConstraints = false

        bottomView.backgroundColor = buttonView.backgroundColor
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false

        setupConstraints()
    }

    @objc private func addPatient() {
        let patientAppointment = PatientAppointment(
            scheduledTime: appointment.scheduledTime,
            duration: appointmentView.duration,
            patient: patientDataInput.patientData
        )
        presenter.updateSchedule(with: patientAppointment)
    }

    private func setupConstraints() {
        patientDataInputTopConstraint = patientDataInput.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: view.frame.height * 0.3
        )

        NSLayoutConstraint.activate([
            appointmentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            appointmentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            appointmentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            appointmentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

            patientDataInputTopConstraint,
            patientDataInput.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            patientDataInput.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            patientDataInput.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

            buttonView.topAnchor.constraint(equalTo: patientDataInput.bottomAnchor),
            buttonView.leadingAnchor.constraint(equalTo: patientDataInput.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: patientDataInput.trailingAnchor),
            buttonView.heightAnchor.constraint(equalToConstant: 70),

            button.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 180),
            button.heightAnchor.constraint(equalToConstant: 50),

            bottomView.topAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: 5),
            bottomView.leadingAnchor.constraint(equalTo: patientDataInput.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: patientDataInput.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        patientDataInputTopConstraint.constant = 0
        view.layoutIfNeeded()
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        patientDataInputTopConstraint.constant = appointmentView.frame.height
        view.layoutIfNeeded()
    }
}

// MARK: - PatientAppointmentView

extension PatientAppointmentViewController: PatientAppointmentView {
    func showError(message: String) {
        let alert = AlertsFactory.makeDefault(message: message)
        present(alert, animated: true)
    }
}
