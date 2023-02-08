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
    private let addPatientButton = UIButton(type: .custom)
    private let patientInfoButton = UIButton(type: .custom)
    private let bottomView = UIView()

    private var appointmentView: PatientAppointmentDataView!

    private var patientDataInputTopConstraint = NSLayoutConstraint()

    private var databasePatient: Patient? {
        didSet {
            patientInfoButton.isHidden = databasePatient == nil
        }
    }

    var schedule: DoctorSchedule!
    var appointment: PatientAppointment!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Design.Color.lightGray

        let searchIcon = UIImage(systemName: "magnifyingglass")
        let rightBarButton = UIBarButtonItem(
            image: searchIcon,
            style: .plain,
            target: self,
            action: #selector(findPatient)
        )
        navigationItem.rightBarButtonItem = rightBarButton

        configureHierarchy()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustForKeyboard(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustForKeyboard(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func configureHierarchy() {
        appointmentView = PatientAppointmentDataView(
            doctor: schedule.doctor,
            date: appointment.scheduledTime,
            serviceDuration: Float(appointment.duration),
            maxServiceDuration: Float(schedule.maxServiceDuration(for: appointment))
        )
        appointmentView.layer.cornerRadius = Design.CornerRadius.large
        appointmentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        patientDataInput.backgroundColor = Design.Color.white

        patientInfoButton.setTitle("Подробнее", for: .normal)
        patientInfoButton.setTitleColor(Design.Color.brown, for: .normal)
        patientInfoButton.titleLabel?.font = Font.titleMedium
        patientInfoButton.isHidden = true
        patientInfoButton.addTarget(self, action: #selector(showPatientCard), for: .touchUpInside)

        buttonView.backgroundColor = Design.Color.white
        addPatientButton.backgroundColor = Design.Color.red
        addPatientButton.setTitle("ЗАПИСАТЬ", for: .normal)
        addPatientButton.setTitleColor(Design.Color.white, for: .normal)
        addPatientButton.layer.cornerRadius = Design.CornerRadius.medium
        addPatientButton.addTarget(self, action: #selector(addPatient), for: .touchUpInside)

        buttonView.addSubview(patientInfoButton)
        buttonView.addSubview(addPatientButton)
        patientInfoButton.translatesAutoresizingMaskIntoConstraints = false
        addPatientButton.translatesAutoresizingMaskIntoConstraints = false

        bottomView.backgroundColor = buttonView.backgroundColor

        for subview in [appointmentView, patientDataInput, buttonView, bottomView].compactMap({ $0 }) {
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }

        setupConstraints()
    }

    @objc private func findPatient() {
        presenter.findPatient()
    }

    @objc private func showPatientCard() {
        guard let patient = patientDataInput.patientData else { return }

        presenter.showPatientCard(patient: patient)
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
            buttonView.heightAnchor.constraint(equalToConstant: 120),

            patientInfoButton.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 10),
            patientInfoButton.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: -10),
            patientInfoButton.heightAnchor.constraint(equalToConstant: 20),
            patientInfoButton.widthAnchor.constraint(equalToConstant: 100),

            addPatientButton.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor),
            addPatientButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: -15),
            addPatientButton.widthAnchor.constraint(equalToConstant: 180),
            addPatientButton.heightAnchor.constraint(equalToConstant: 50),

            bottomView.topAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: 5),
            bottomView.leadingAnchor.constraint(equalTo: patientDataInput.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: patientDataInput.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func animateWithKeyboard(
        notification: Notification,
        animations: (() -> Void)?
    ) {
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey

        guard let duration = notification.userInfo?[durationKey] as? Double,
              let curveValue = notification.userInfo?[curveKey] as? Int,
              let curve = UIView.AnimationCurve(rawValue: curveValue) else { return }

        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) {
            animations?()
        }

        animator.startAnimation()
    }

    @objc private func adjustForKeyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            animateWithKeyboard(notification: notification) {
                self.patientDataInputTopConstraint.constant = self.appointmentView.frame.height
                self.view.layoutIfNeeded()
            }
        } else {
            animateWithKeyboard(notification: notification) {
                self.patientDataInputTopConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - PatientAppointmentView

extension PatientAppointmentViewController: PatientAppointmentView {
    func inputData(with patient: Patient) {
        patientDataInput.inputData(with: patient)
        databasePatient = patient
    }
}
