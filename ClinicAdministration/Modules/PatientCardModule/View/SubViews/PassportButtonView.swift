//
//  PassportButtonView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 17.12.2022.
//

import UIKit

final class PassportButtonView: UIView {
    private var color: UIColor {
        Design.Color.brown
    }

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
        layer.borderColor = color.cgColor
        layer.borderWidth = 1

        let label = UILabel()
        label.text = "Паспортные данные"
        label.textColor = color
        label.font = Design.Font.robotoFont(ofSize: 20, weight: .bold)

        let image = UIImage(named: "chevron_right")?.withTintColor(color)
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
