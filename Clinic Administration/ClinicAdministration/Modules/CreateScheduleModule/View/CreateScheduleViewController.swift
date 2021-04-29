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

    func pickDoctor() {
    }

    func pickTimeInterval() {
    }

    func pickCabinet() {
    }
}

// MARK: - CreateScheduleDisplaying

extension CreateScheduleViewController: CreateScheduleDisplaying {
}
