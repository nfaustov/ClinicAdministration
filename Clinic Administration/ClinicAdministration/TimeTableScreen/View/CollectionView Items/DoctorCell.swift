//
//  DoctorCell.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 26.03.2021.
//

import UIKit
import Design

final class DoctorCell: UICollectionViewCell {
    static let reuseIdentifier: String = "DoctorCell"

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 17, weight: .medium)
        label.textColor = Design.Color.chocolate
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let specializationLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 14, weight: .light)
        label.textColor = Design.Color.chocolate
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()

    private var gradientLayer: CAGradientLayer!

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.backgroundColor = Design.Color.white.cgColor
        layer.cornerRadius = Design.CornerRadius.medium
        layer.borderWidth = 1
        layer.borderColor = Design.Color.darkGray.cgColor

//        gradientLayer = CAGradientLayer()
//        gradientLayer.startPoint = CGPoint(x: frame.width / 2, y: 0)
//        gradientLayer.endPoint = CGPoint(x: frame.width / 2, y: frame.height)
//        gradientLayer.colors = [Design.Color.lightGray.cgColor, Design.Color.white.cgColor]
//        layer.insertSublayer(gradientLayer, at: 0)

        [nameLabel, specializationLabel].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            specializationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            specializationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            specializationLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10),

            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with doctor: DoctorSchedule) {
        specializationLabel.text = "\(doctor.specialization)"
        nameLabel.text = "\(doctor.secondName)\n\(doctor.firstName)\n\(doctor.patronymicName)"
    }
}
