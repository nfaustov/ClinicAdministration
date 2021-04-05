//
//  PatientSectionBackgroundDecorationView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 02.04.2021.
//

import UIKit
import Design

final class PatientSectionBackgroundDecorationView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        let view = UIView()
        view.layer.backgroundColor = Design.Color.chocolate.cgColor
        view.layer.cornerRadius = Design.CornerRadius.large
        addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
