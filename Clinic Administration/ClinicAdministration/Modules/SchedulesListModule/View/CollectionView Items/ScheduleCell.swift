//
//  ScheduleCell.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 14.10.2021.
//

import UIKit

final class ScheduleCell: UICollectionViewCell, SelfConfiguredCell {
    static let reuseIdentifier: String = "ScheduleCell"

    let dateLabel = UILabel()
    let intervalLabel = UILabel()
    let dateView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Design.Color.white
        layer.cornerRadius = Design.CornerRadius.medium
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = Design.Color.darkGray.cgColor
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
        dateLabel.text = formatter.string(from: schedule.startingTime)
        dateLabel.textColor = Design.Color.white
        dateLabel.font = Design.Font.robotoFont(ofSize: 17, weight: .regular)
        formatter.dateFormat = "H:mm"
        let startingTime = formatter.string(from: schedule.startingTime)
        let endingTime = formatter.string(from: schedule.endingTime)
        intervalLabel.text = "\(startingTime) - \(endingTime)"
        intervalLabel.textColor = Design.Color.chocolate
        intervalLabel.font = Design.Font.robotoFont(ofSize: 20, weight: .medium)

        dateView.backgroundColor = Design.Color.darkGray
        dateView.layer.cornerRadius = layer.cornerRadius
        dateView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
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
