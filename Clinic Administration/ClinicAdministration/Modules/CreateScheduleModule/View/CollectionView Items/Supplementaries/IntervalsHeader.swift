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
        let label = UILabel()
        label.text = "Доступные интервалы времени"
        label.font = Design.Font.robotoFont(ofSize: 14, weight: .regular)
        label.textColor = Design.Color.darkGray
        label.textAlignment = .center
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
