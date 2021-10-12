//
//  DoctorControlCell.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 26.04.2021.
//

import UIKit

class DoctorControlCell: UICollectionViewCell, SelfConfiguredCell {
    static let reuseIdentifier = "DoctorHeader"

    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "user_plus"), for: .normal)
        button.backgroundColor = Design.Color.brown.withAlphaComponent(0.15)
        button.layer.cornerRadius = Design.CornerRadius.medium
        return button
    }()
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "user_close"), for: .normal)
        button.backgroundColor = Design.Color.brown.withAlphaComponent(0.15)
        button.layer.cornerRadius = Design.CornerRadius.medium
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        [plusButton, deleteButton].forEach { button in
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

    func configure(with model: DoctorControl) {
        plusButton.addTarget(model.target, action: model.addAction, for: .touchUpInside)
        deleteButton.addTarget(model.target, action: model.deleteAction, for: .touchUpInside)
    }
}
