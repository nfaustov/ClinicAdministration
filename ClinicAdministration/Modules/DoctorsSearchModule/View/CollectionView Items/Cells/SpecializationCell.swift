//
//  SpecializationCell.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 07.12.2022.
//

import UIKit

final class SpecializationCell: UICollectionViewCell, SelfConfiguredCell {
    static let reuseIdentifier = "SpecializationCell"

    let label: UILabel = {
        let label = Label.labelSmall(color: Design.Color.brown)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? Design.Color.chocolate : Design.Color.lightGray
            label.textColor = isSelected ? Design.Color.lightGray : Design.Color.brown
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Design.Color.lightGray
        layer.cornerRadius = Design.CornerRadius.small

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String) {
        isSelected = false
        label.text = title
    }
}
