//
//  CheckButton.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 17.12.2022.
//

import UIKit

final class CheckButton: UIView {
    private let title: String
    private let image: UIImage?

    private var gradientLayer: CAGradientLayer = {
       let layer = CAGradientLayer()
        let startColor = CGColor(red: 0.73, green: 0.33, blue: 0.10, alpha: 1)
        let endColor = CGColor(red: 0.9, green: 0.37, blue: 0.07, alpha: 1)
        layer.colors = [startColor, endColor]
        layer.startPoint = CGPoint(x: 0.5, y: 0.14)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        return layer
    }()

    init(title: String, image: UIImage? = nil) {
        self.title = title
        self.image = image
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        layer.addSublayer(gradientLayer)

        let label = UILabel()
        label.text = title
        label.textColor = Design.Color.white
        label.font = Design.Font.robotoFont(ofSize: 20, weight: .bold)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor , constant: -10)
        ])

        guard let image = image else { return }

        let imageView = UIImageView(image: image)
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: label.trailingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
