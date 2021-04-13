//
//  DoctorCell.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 26.03.2021.
//

import UIKit
import Design

final class DoctorCell: UICollectionViewCell, TimeTableCell {
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

    private var gradientLayer: CAGradientLayer = {
       let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Design.Color.lightGray.cgColor, Design.Color.lightGray.withAlphaComponent(0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.8)
        return gradientLayer
    }()

    override var isSelected: Bool {
        didSet {
            layer.shadowColor = isSelected ? Design.Color.brown.cgColor : Design.Color.darkGray.cgColor
            transform = isSelected ? CGAffineTransform(scaleX: 1.08, y: 1.08) : .identity
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.backgroundColor = Design.Color.white.cgColor
        layer.cornerRadius = Design.CornerRadius.medium
        layer.borderWidth = 1
        layer.borderColor = Design.Color.darkGray.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: Design.CornerRadius.medium).cgPath
        layer.shadowColor = Design.Color.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 9
        layer.shadowOpacity = 0.4
        layer.addSublayer(gradientLayer)
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = Design.CornerRadius.medium

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
