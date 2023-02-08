//
//  DoctorPlaceholder.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 12.04.2021.
//

import UIKit

class DoctorPlaceholder: UICollectionViewCell, SelfConfiguredCell {
    static let reuseIdentifier = "DoctorPlaceholder"

    let messageLabel = Label.titleMedium(color: Design.Color.chocolate)

    let createScheduleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = Design.Color.white
        button.layer.cornerRadius = Design.CornerRadius.small
        button.layer.shadowColor = Design.Color.brown.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.2
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        [messageLabel, createScheduleButton].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            createScheduleButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30),
            createScheduleButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            createScheduleButton.heightAnchor.constraint(equalToConstant: 30),
            createScheduleButton.widthAnchor.constraint(equalToConstant: 175)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        createScheduleButton.layer.shadowPath = UIBezierPath(
            roundedRect: createScheduleButton.bounds,
            cornerRadius: Design.CornerRadius.small
        ).cgPath
    }

    func configure(with model: DoctorSectionPlaceholder) {
        messageLabel.text = model.message
        createScheduleButton.setTitle(model.buttonTitle, for: .normal)
        createScheduleButton.setTitleColor(Design.Color.chocolate, for: .normal)
        createScheduleButton.titleLabel?.font = Font.titleSmall
        createScheduleButton.addTarget(model.target, action: model.action, for: .touchUpInside)
    }
}
