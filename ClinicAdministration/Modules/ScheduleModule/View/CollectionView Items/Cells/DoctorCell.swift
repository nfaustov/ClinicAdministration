//
//  DoctorCell.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 26.03.2021.
//

import UIKit

final class DoctorCell: UICollectionViewCell, SelfConfiguredCell {
    static let reuseIdentifier: String = "DoctorCell"

    private let nameLabel: UILabel = {
        let label = Label.titleLarge(color: Color.label)
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let specializationLabel: UILabel = {
        let label = Label.labelLarge(color: Color.label)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()

    private var gradientLayer: CAGradientLayer = {
       let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Color.background.cgColor, Color.background.withAlphaComponent(0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.8)
        return gradientLayer
    }()

    override var isSelected: Bool {
        didSet {
            layer.shadowColor = isSelected ? Color.selectedShadow.cgColor : Color.passiveShadow.cgColor
            transform = isSelected ? CGAffineTransform(scaleX: 1.08, y: 1.08) : .identity
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.backgroundColor = Color.secondaryBackground.cgColor
        layer.cornerRadius = Design.CornerRadius.medium
        layer.borderWidth = 1
        layer.borderColor = Color.border.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: Design.CornerRadius.medium).cgPath
        layer.shadowColor = Color.passiveShadow.cgColor
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

    func configure(with schedule: DoctorSchedule) {
        specializationLabel.text = "\(schedule.doctor.specialization)"
        nameLabel.text = """
        \(schedule.doctor.secondName)
        \(schedule.doctor.firstName)
        \(schedule.doctor.patronymicName)
        """
    }
}
