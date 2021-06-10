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

    var date = Date() {
        didSet {
            schedulePicker?.date = date
        }
    }

    var doctor: Doctor?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Расписание врача"

        view.backgroundColor = Design.Color.lightGray

        configurePicker()
        configureConfirmation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func configurePicker() {
        schedulePicker = SchedulePicker(date: date)
        schedulePicker.delegate = self
        view.addSubview(schedulePicker)

        schedulePicker.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            schedulePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            schedulePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            schedulePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            schedulePicker.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func configureConfirmation() {
    }

    @objc private func addDoctroSchedule() {
//        guard let cabinet = schedulePicker.cabinet,
//              let interval = schedulePicker.interval else { return }

//        let schedule = DoctorSchedule(
//            id: UUID(),
//            secondName: doctor.secondName,
//            firstName: doctor.firstName,
//            patronymicName: doctor.patronymicName,
//            phoneNumber: doctor.phoneNumber,
//            specialization: doctor.specialization,
//            cabinet: cabinet,
//            startingTime: interval.0,
//            endingTime: interval.1,
//            serviceDuration: doctor.serviceDuration
//        )

//        presenter.addSchedule(schedule)
    }

    @objc private func cancelDoctorSchedule() {
    }
}

// MARK: - SchedulePickerDelegate

extension CreateScheduleViewController: SchedulePickerDelegate {
    func pickDate() {
        presenter.pickDateInCalendar()
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
    }

    func pickedInterval(_ interval: (Date, Date)) {
        schedulePicker.interval = interval
    }

    func pickedCabinet(_ cabinet: Int) {
        schedulePicker.cabinet = cabinet
    }
}
