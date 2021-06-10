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

    private var doctorView: DoctorView!

    private var scheduleDateView: SchedulePropertyView!
    private var scheduleCabinetView: SchedulePropertyView!

    var date = Date() {
        didSet {
            scheduleDateView.date = date
        }
    }

    var doctor: Doctor? {
        didSet {
            configureHierarchy()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Расписание врача"

        view.backgroundColor = Design.Color.lightGray
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if doctor == nil {
            presenter.pickDoctor()
        }
    }

    private func configureHierarchy() {
        guard let doctor = doctor else { return }

        doctorView = DoctorView(doctor: doctor, pickDoctorAction: presenter.pickDoctor)

        var defaultCabinetText: String

        if let cabinet = doctor.defaultCabinet {
            defaultCabinetText = "\(cabinet) (По умолчанию)"
        } else {
            defaultCabinetText = "--"
        }
        scheduleDateView = SchedulePropertyView(title: "Дата", date: date)
        scheduleCabinetView = SchedulePropertyView(title: "Кабинет", valuePlaceholder: defaultCabinetText)

        [doctorView, scheduleDateView, scheduleCabinetView].compactMap { $0 }.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            doctorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            doctorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            doctorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            doctorView.heightAnchor.constraint(equalToConstant: 330),

            scheduleDateView.topAnchor.constraint(equalTo: doctorView.bottomAnchor, constant: 30),
            scheduleDateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scheduleDateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scheduleDateView.heightAnchor.constraint(equalToConstant: 60),

            scheduleCabinetView.topAnchor.constraint(equalTo: scheduleDateView.bottomAnchor, constant: 30),
            scheduleCabinetView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scheduleCabinetView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scheduleCabinetView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc private func addDoctorSchedule() {
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
}

// MARK: - CreateScheduleDisplaying

extension CreateScheduleViewController: CreateScheduleDisplaying {
    func pickedDoctor(_ doctor: Doctor) {
    }

    func pickedInterval(_ interval: (Date, Date)) {
    }

    func pickedCabinet(_ cabinet: Int) {
        scheduleCabinetView.value = "\(cabinet)"
    }
}
