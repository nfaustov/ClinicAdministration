//
//  ActionListCell.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 06.04.2021.
//

import UIKit
import Design

class ActionListCell: UICollectionViewCell {
    static let reuseIdentifier = "ActionListCell"

    var imageView: UIImageView!

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 16, weight: .regular)
        label.textColor = Design.Color.chocolate
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.backgroundColor = Design.Color.white.cgColor
        layer.borderWidth = 1
        layer.borderColor = Design.Color.darkGray.cgColor

        addSubview(nameLabel)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with action: TimeTableAction) {
        nameLabel.text = action.name
        imageView?.image = nil

        guard let icon = action.icon else { return }

        imageView = UIImageView()
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
