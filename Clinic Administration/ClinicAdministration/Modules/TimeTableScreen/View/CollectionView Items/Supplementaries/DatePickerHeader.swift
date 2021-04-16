//
//  DatePickerHeader.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 01.04.2021.
//

import UIKit
import DatePicker

final class DatePickerHeader: UICollectionReusableView {
    static let reuseIdentifier = "DatePickerHeader"

    private var datePicker: DatePicker!

    func configure(with date: Date, presenter: TimeTablePresentation) {
        if let datePicker = datePicker {
            datePicker.removeFromSuperview()
        }

        datePicker = DatePicker(
            selectedDate: date,
            dateAction: { date in
                presenter.didSelected(date: date)
            },
            calendarAction: { viewController in
                presenter.openCalendar(viewController)
            }
        )

        addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            datePicker.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
}
