//
//  PatientItemCell.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 15.12.2022.
//

import UIKit

final class PatientItemCell: UICollectionViewCell, SelfConfiguredCell {
    static let reuseIdentifier = "PatientItemCell"

    let nameLabel: UILabel = {
        let label = Label.titleMedium(color: Color.label)
        label.numberOfLines = 2
        return label
    }()

    let phoneLabel = Label.thin(ofSize: .titleSmall, color: Color.label)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Color.secondaryBackground
        layer.cornerRadius = Design.CornerRadius.small
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = Color.shadow.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 5

        addSubview(nameLabel)
        addSubview(phoneLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            phoneLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            phoneLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            phoneLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: Design.CornerRadius.small).cgPath
    }

    func configure(with patient: Patient) {
        nameLabel.text = patient.fullName
        phoneLabel.text = patient.phoneNumber
    }
}
