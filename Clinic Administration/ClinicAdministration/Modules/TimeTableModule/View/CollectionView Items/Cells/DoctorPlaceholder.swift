//
//  DoctorPlaceholder.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 12.04.2021.
//

import UIKit

class DoctorPlaceholder: UICollectionViewCell, TimeTableCell {
    static let reuseIdentifier = "DoctorPlaceholder"

    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 15, weight: .bold)
        label.textColor = Design.Color.chocolate
        return label
    }()

    let addFirstScheduleButton: UIButton = {
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

        [messageLabel, addFirstScheduleButton].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            addFirstScheduleButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30),
            addFirstScheduleButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addFirstScheduleButton.heightAnchor.constraint(equalToConstant: 30),
            addFirstScheduleButton.widthAnchor.constraint(equalToConstant: 175)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        addFirstScheduleButton.layer.shadowPath = UIBezierPath(
            roundedRect: addFirstScheduleButton.bounds,
            cornerRadius: Design.CornerRadius.small
        ).cgPath
    }

    func configure(with model: DoctorSectionPlaceholder) {
        messageLabel.text = model.message
        addFirstScheduleButton.setTitle(model.buttonTitle, for: .normal)
        addFirstScheduleButton.setTitleColor(Design.Color.chocolate, for: .normal)
        addFirstScheduleButton.titleLabel?.font = Design.Font.robotoFont(ofSize: 13, weight: .medium)
        addFirstScheduleButton.addTarget(model.target, action: model.action, for: .touchUpInside)
    }
}
