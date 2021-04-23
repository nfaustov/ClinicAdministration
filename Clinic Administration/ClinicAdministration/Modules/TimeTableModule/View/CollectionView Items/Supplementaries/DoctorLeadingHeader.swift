//
//  DoctorLeadingHeader.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 03.04.2021.
//

import UIKit

final class DoctorLeadingHeader: UICollectionReusableView {
    static let reuseIdentifier = "DoctorHeader"

    override init(frame: CGRect) {
        super.init(frame: frame)

        let plusButton = UIButton(type: .custom)
        plusButton.setImage(UIImage(named: "user_plus"), for: .normal)
        let deleteButton = UIButton(type: .custom)
        deleteButton.setImage(UIImage(named: "user_close"), for: .normal)

        for button in [plusButton, deleteButton] {
            button.backgroundColor = Design.Color.brown.withAlphaComponent(0.15)
            button.layer.cornerRadius = Design.CornerRadius.medium
            addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            deleteButton.widthAnchor.constraint(equalToConstant: 48),
            deleteButton.heightAnchor.constraint(equalToConstant: 48),

            plusButton.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 12),
            plusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            plusButton.widthAnchor.constraint(equalToConstant: 48),
            plusButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
