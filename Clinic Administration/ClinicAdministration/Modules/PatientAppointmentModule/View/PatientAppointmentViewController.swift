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

    var schedule: DoctorSchedule!
    var appointment: PatientAppointment!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Design.Color.lightGray

        let patientDataInput = PatientDataView()
        patientDataInput.backgroundColor = Design.Color.white
        view.addSubview(patientDataInput)
        patientDataInput.frame = CGRect(x: 20, y: 200, width: view.bounds.width - 40, height: 200)

        let patientApointmentDataView = PatientAppointmentDataView(
            doctor: schedule.doctor,
            date: schedule.startingTime,
            scheduledTime: appointment.scheduledTime ?? Date()
        )
        view.addSubview(patientApointmentDataView)
        patientApointmentDataView.frame = CGRect(x: 20, y: 0, width: view.bounds.width - 40, height: 200)
    }
}

// MARK: - PatientAppointmentView

extension PatientAppointmentViewController: PatientAppointmentView {
}
