//
//  ActionListBackgroundDecorationView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 10.04.2021.
//

import UIKit
import Design

final class ActionListBackgroundDecorationView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        let view = UIView()
        view.layer.backgroundColor = Design.Color.white.cgColor
        view.layer.cornerRadius = Design.CornerRadius.small
        view.layer.borderWidth = 1
        view.layer.borderColor = Design.Color.gray.cgColor
        addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            view.heightAnchor.constraint(equalToConstant: 135)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
