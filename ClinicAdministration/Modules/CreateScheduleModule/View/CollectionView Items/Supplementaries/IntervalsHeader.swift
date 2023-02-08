//
//  IntervalsHeader.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 06.12.2022.
//

import UIKit

final class IntervalsHeader: UICollectionReusableView {
    static let reuseIdentifier = "IntervalsHeader"

    func configure() {
        let label = Label.labelLarge(color: Design.Color.darkGray, withText: "Доступные интервалы времени")
        label.textAlignment = .center
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
