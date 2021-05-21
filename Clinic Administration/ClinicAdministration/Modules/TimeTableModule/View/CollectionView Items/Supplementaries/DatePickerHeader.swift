//
//  DatePickerHeader.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 01.04.2021.
//

import UIKit

final class DatePickerHeader: UICollectionReusableView {
    static let reuseIdentifier = "DatePickerHeader"

    func configure(with datePicker: DatePicker) {
        addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor),
            datePicker.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
}
