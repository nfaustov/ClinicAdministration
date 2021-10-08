//
//  OptionCell.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 14.06.2021.
//

import UIKit

final class OptionCell: UICollectionViewCell, SelfConfiguredCell {
    static var reuseIdentifier: String = "OptionCell"

    private var scheduleOptionView: ScheduleOptionView!

    func configure(with option: ScheduleOption) {
        if let date = option.date {
            scheduleOptionView = ScheduleOptionView(title: option.title, date: date)
        } else {
            scheduleOptionView = ScheduleOptionView(title: option.title, valuePlaceholder: option.placeholder)
        }

        addSubview(scheduleOptionView)
        scheduleOptionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scheduleOptionView.topAnchor.constraint(equalTo: topAnchor),
            scheduleOptionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scheduleOptionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scheduleOptionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
