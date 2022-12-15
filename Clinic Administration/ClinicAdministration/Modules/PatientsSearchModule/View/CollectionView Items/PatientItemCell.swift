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
       let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 14, weight: .regular)
        label.textColor = Design.Color.chocolate
        label.numberOfLines = 2
        return label
    }()
    let phoneLabel: UILabel = {
       let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 14, weight: .regular)
        label.textColor = Design.Color.chocolate
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Design.Color.white
        layer.cornerRadius = Design.CornerRadius.small

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

    func configure(with patient: Patient) {
        nameLabel.text = patient.fullName
        phoneLabel.text = patient.phoneNumber
    }
}
