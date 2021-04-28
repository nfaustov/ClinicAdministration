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

        schedulePicker = SchedulePicker(
            date: date,
            calendarAction: presenter.pickDateInCalendar,
            doctorAction: presenter.pickDoctor
        )
        schedulePicker.frame = CGRect(x: 0, y: 200, width: view.frame.width, height: 50)
        view.addSubview(schedulePicker)
    }
}

// MARK: - CreateScheduleDisplaying

extension CreateScheduleViewController: CreateScheduleDisplaying {
}
