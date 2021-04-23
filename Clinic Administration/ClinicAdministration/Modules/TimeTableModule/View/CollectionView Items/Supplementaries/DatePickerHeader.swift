//
//  DatePickerHeader.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 01.04.2021.
//

import UIKit

final class DatePickerHeader: UICollectionReusableView {
    static let reuseIdentifier = "DatePickerHeader"

    func configure(with date: Date, datePicker: DatePicker) {
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
