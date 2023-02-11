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
        layer.colors = [
            UIColor(red: 0.286, green: 0.129, blue: 0.039, alpha: 1).cgColor,
            UIColor(red: 0.396, green: 0.157, blue: 0.024, alpha: 0).cgColor
        ]
        layer.locations = [0, 1]
        layer.startPoint = CGPoint(x: 0.5, y: 0.86)
        layer.endPoint = CGPoint(x: 0.5, y: 0.0)
        return layer
    }()

    override var bounds: CGRect {
        didSet {
            gradientLayer.frame = bounds.insetBy(dx: -0.5 * bounds.size.width, dy: -0.5 * bounds.size.height)
        }
    }

    init(title: String, image: UIImage? = nil) {
        self.title = title
        self.image = image
        super.init(frame: .zero)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        layer.backgroundColor = Color.fill.cgColor
        layer.cornerRadius = Design.CornerRadius.medium
        layer.masksToBounds = true
        layer.addSublayer(gradientLayer)
        gradientLayer.cornerRadius = Design.CornerRadius.medium

        let label = Label.headlineSmall(color: Color.lightLabel, withText: title)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10)
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
