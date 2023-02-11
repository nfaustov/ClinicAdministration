//
//  ScheduleCell.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 14.10.2021.
//

import UIKit

final class ScheduleCell: UICollectionViewCell, SelfConfiguredCell {
    static let reuseIdentifier: String = "ScheduleCell"

    let dateLabel = Label.titleLarge(color: Color.lightLabel)
    let intervalLabel = Label.headlineSmall(color: Color.label)
    let dateView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Color.secondaryBackground
        layer.masksToBounds = true
        layer.cornerRadius = Design.CornerRadius.small
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = Color.passiveShadow.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 7
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with schedule: DoctorSchedule) {
        let formatter = DateFormatter.shared
        formatter.dateFormat = "LLLL d"
        dateLabel.numberOfLines = 2
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.textAlignment = .center
        dateLabel.text = formatter.string(from: schedule.starting)
        formatter.dateFormat = "H:mm"
        let startingTime = formatter.string(from: schedule.starting)
        let endingTime = formatter.string(from: schedule.ending)
        intervalLabel.text = "\(startingTime) - \(endingTime)"

        dateView.layer.backgroundColor = Color.tertiaryFill.cgColor
        addSubview(dateView)
        dateView.translatesAutoresizingMaskIntoConstraints = false

        dateView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(intervalLabel)
        intervalLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dateView.heightAnchor.constraint(equalTo: heightAnchor),
            dateView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),

            dateLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor, constant: 8),
            dateLabel.centerYAnchor.constraint(equalTo: dateView.centerYAnchor),
            dateLabel.trailingAnchor.constraint(
                lessThanOrEqualToSystemSpacingAfter: dateView.trailingAnchor,
                multiplier: 0.25
            ),

            intervalLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            intervalLabel.leadingAnchor.constraint(equalTo: dateView.trailingAnchor, constant: 20),
            intervalLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20)
        ])
    }
}
