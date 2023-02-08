//
//  ActionListCell.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 06.04.2021.
//

import UIKit

class ActionListCell: UICollectionViewCell, SelfConfiguredCell {
    static let reuseIdentifier = "ActionListCell"

    private let nameLabel: UILabel = {
        let label = Label.titleMedium(color: Design.Color.chocolate)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = Design.CornerRadius.small

        let separator = UIView()
        separator.backgroundColor = Design.Color.gray

        [nameLabel, separator].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10),

            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with action: ScheduleAction) {
        nameLabel.text = action.name

        guard let icon = action.icon else { return }

        let imageView = UIImageView()
        imageView.image = icon.withTintColor(Design.Color.brown)
        addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
