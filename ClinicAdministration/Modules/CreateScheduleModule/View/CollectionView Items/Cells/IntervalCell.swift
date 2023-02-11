//
//  IntervalCell.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 07.10.2021.
//

import UIKit

final class IntervalCell: UICollectionViewCell, SelfConfiguredCell {
    static let reuseIdentifier: String = "IntervalCell"

    private let startingLabel = Label.headlineMedium(color: Color.secondaryLabel)
    private let endingLabel = Label.headlineMedium(color: Color.secondaryLabel)

    func configure(with interval: DateInterval) {
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        layer.backgroundColor = Color.secondaryBackground.cgColor
        layer.cornerRadius = Design.CornerRadius.medium
        layer.shadowColor = Color.selectedShadow.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8

        DateFormatter.shared.dateFormat = "H:mm"
        startingLabel.text = DateFormatter.shared.string(from: interval.start)
        endingLabel.text = DateFormatter.shared.string(from: interval.end)

        let separator = UIView()
        separator.backgroundColor = Color.lightSeparator

        [startingLabel, endingLabel, separator].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            startingLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            startingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            separator.centerYAnchor.constraint(equalTo: centerYAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            separator.heightAnchor.constraint(equalToConstant: 1),

            endingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            endingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
