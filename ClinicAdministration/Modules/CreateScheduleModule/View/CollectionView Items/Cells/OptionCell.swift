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

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = Design.CornerRadius.large
        layer.shadowColor = Color.selectedShadow.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.35
        layer.shadowRadius = 8
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
