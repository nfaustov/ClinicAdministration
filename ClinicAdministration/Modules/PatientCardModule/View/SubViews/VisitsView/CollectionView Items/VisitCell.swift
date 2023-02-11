//
//  VisitCell.swift
//  ClinicAdministration
//
//  Created by Николай Фаустов on 07.02.2023.
//

import UIKit

final class VisitCell: UICollectionViewCell, SelfConfiguredCell {
    static let reuseIdentifier = "VisitCell"

    func configure(with: Visit) {
        layer.backgroundColor = Color.background.cgColor
        layer.cornerRadius = Design.CornerRadius.large
    }
}
