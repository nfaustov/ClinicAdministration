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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Design.Color.lightGray

        schedulePicker = SchedulePicker(date: date)
        schedulePicker.frame = CGRect(x: 0, y: 200, width: view.frame.width, height: 100)
        view.addSubview(schedulePicker)
        schedulePicker.delegate = self
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
