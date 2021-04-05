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

    override init(frame: CGRect) {
        super.init(frame: frame)

        datePicker = DatePicker()
        addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            datePicker.heightAnchor.constraint(equalToConstant: 90)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with date: Date, presenter: TimeTablePresentation) {
        datePicker.selectedDate = date
        datePicker.dateAction = presenter.didSelected(date:)
        datePicker.calendarAction = presenter.calendarRequired
    }
}
