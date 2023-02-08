//
//  PassportButtonView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 17.12.2022.
//

import UIKit

final class PassportButtonView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        layer.backgroundColor = Design.Color.white.cgColor
        layer.cornerRadius = Design.CornerRadius.medium
        layer.borderColor = Design.Color.brown.cgColor
        layer.borderWidth = 1

        let label = Label.headlineSmall(color: Design.Color.brown, withText: "Паспортные данные")

        let image = UIImage(named: "chevron_right")?.withTintColor(Design.Color.brown)
        let imageView = UIImageView(image: image)

        for view in [label, imageView] {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(lessThanOrEqualTo: imageView.leadingAnchor, constant: -10),

            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
