//
//  ActionListBackgroundDecorationView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 10.04.2021.
//

import UIKit

final class ActionListBackgroundDecorationView: UICollectionReusableView {
    static let reuseIdentifier = "ActionListBackgroundDecorationView"

    override init(frame: CGRect) {
        super.init(frame: frame)

        let view = UIView()
        view.layer.backgroundColor = Color.secondaryBackground.cgColor
        view.layer.cornerRadius = Design.CornerRadius.small
        view.layer.borderWidth = 1
        view.layer.borderColor = Color.separator.cgColor
        addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.heightAnchor.constraint(equalToConstant: 135)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
