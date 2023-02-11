//
//  DoctorItemCell.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 03.06.2021.
//

import UIKit

final class DoctorItemCell: UICollectionViewCell, SelfConfiguredCell {
    static let reuseIdentifier = "DoctorItemCell"

    let label: UILabel = {
        let label = Label.labelLarge(color: Color.label)
        label.numberOfLines = 2
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Color.secondaryBackground
        layer.cornerRadius = Design.CornerRadius.small
        layer.borderWidth = 1
        layer.borderColor = Color.lightBorder.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = Color.passiveShadow.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 7

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: Design.CornerRadius.small).cgPath
    }

    func configure(with doctor: Doctor) {
        label.text = doctor.fullName
    }
}
