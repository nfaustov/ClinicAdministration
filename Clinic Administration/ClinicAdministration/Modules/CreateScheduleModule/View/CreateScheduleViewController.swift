//
//  CreateScheduleViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 27.04.2021.
//

import UIKit

final class CreateScheduleViewController: UIViewController {
    typealias PresenterType = CreateSchedulePresentation
    var presenter: PresenterType!

    private var schedulePicker: SchedulePicker!

    private var confirmationBottomContstraint: NSLayoutConstraint!
    private var schedulePickerTopConstraint: NSLayoutConstraint!

    var date = Date() {
        didSet {
            schedulePicker?.date = date
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Расписание врача"

        view.backgroundColor = Design.Color.lightGray

        configurePicker()
        configureConfirmation()
    }

    private func configurePicker() {
        schedulePicker = SchedulePicker(date: date)
        schedulePicker.delegate = self
        view.addSubview(schedulePicker)

        schedulePicker.translatesAutoresizingMaskIntoConstraints = false

        schedulePickerTopConstraint = schedulePicker.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 50
        )

        NSLayoutConstraint.activate([
            schedulePickerTopConstraint,
            schedulePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            schedulePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            schedulePicker.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func configureConfirmation() {
        let confirmationView = UIView()
        confirmationView.backgroundColor = Design.Color.white
        confirmationView.layer.borderWidth = 1
        confirmationView.layer.borderColor = Design.Color.darkGray.cgColor

        let addButton = UIButton()
        addButton.backgroundColor = Design.Color.red
        addButton.layer.cornerRadius = Design.CornerRadius.medium
        addButton.setTitle("ДОБАВИТЬ", for: .normal)
        addButton.setTitleColor(Design.Color.white, for: .normal)
        addButton.addTarget(self, action: #selector(addDoctroSchedule), for: .touchUpInside)

        let cancelButton = UIButton()
        cancelButton.backgroundColor = Design.Color.gray
        cancelButton.layer.cornerRadius = Design.CornerRadius.medium
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = Design.Color.chocolate.cgColor
        cancelButton.setTitle("ОТМЕНА", for: .normal)
        cancelButton.setTitleColor(Design.Color.brown, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelDoctorSchedule), for: .touchUpInside)

        view.addSubview(confirmationView)
        confirmationView.addSubview(addButton)
        confirmationView.addSubview(cancelButton)

        confirmationView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        confirmationBottomContstraint = confirmationView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: -430
        )

        NSLayoutConstraint.activate([
            confirmationView.topAnchor.constraint(equalTo: schedulePicker.bottomAnchor),
            confirmationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confirmationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confirmationBottomContstraint,

            cancelButton.leadingAnchor.constraint(equalTo: confirmationView.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: confirmationView.bottomAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.widthAnchor.constraint(equalTo: addButton.widthAnchor),

            addButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: confirmationView.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            addButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor)
        ])
    }

    @objc private func addDoctroSchedule() {
        UIView.animate(withDuration: 0.3) {
            self.schedulePickerTopConstraint.constant = 0
            self.confirmationBottomContstraint.constant = -20
            self.view.layoutIfNeeded()
        }
    }

    @objc private func cancelDoctorSchedule() {
    }
}

// MARK: - SchedulePickerDelegate

extension CreateScheduleViewController: SchedulePickerDelegate {
    func pickDate() {
        presenter.pickDateInCalendar()
    }

    func pickDoctor(selected doctor: Doctor?) {
        presenter.pickDoctor(selected: doctor)
    }

    func pickTimeInterval(selected interval: (Date, Date)?) {
        presenter.pickTimeInterval(availableOnDate: date, selected: interval)
    }

    func pickCabinet(selected cabinet: Int?) {
        presenter.pickCabinet(selected: cabinet)
    }
}

// MARK: - CreateScheduleDisplaying

extension CreateScheduleViewController: CreateScheduleDisplaying {
    func pickedDoctor(_ doctor: Doctor) {
        schedulePicker.doctor = doctor
    }

    func pickedInterval(_ interval: (Date, Date)) {
        schedulePicker.interval = interval
    }

    func pickedCabinet(_ cabinet: Int) {
        schedulePicker.cabinet = cabinet
    }
}
