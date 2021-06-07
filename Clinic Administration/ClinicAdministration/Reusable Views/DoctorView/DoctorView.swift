//
//  DoctorView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 06.06.2021.
//

import UIKit

class DoctorView: UIView {
    private var image = UIView()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 18, weight: .medium)
        label.textColor = Design.Color.chocolate
        label.numberOfLines = 2
        return label
    }()
    private let specializationLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 18, weight: .light)
        label.textColor = Design.Color.brown
        label.numberOfLines = 2
        return label
    }()
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 16, weight: .light)
        label.textColor = Design.Color.brown
        label.numberOfLines = 2
        return label
    }()
    private let durationValueLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 16, weight: .regular)
        label.textColor = Design.Color.brown
        label.numberOfLines = 2
        return label
    }()
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 16, weight: .light)
        label.textColor = Design.Color.chocolate
        label.numberOfLines = 0
        return label
    }()

    private var doctor: Doctor

    init(doctor: Doctor) {
        self.doctor = doctor
        super.init(frame: .zero)

        configureImageView()
        configureShortInfoStack()
        configureInfoLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureImageView() {
        if let imageData = doctor.imageData, let photo = UIImage(data: imageData) {
            let imageView = UIImageView(image: photo)
            addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            image = imageView
        } else {
            let imagePlaceholder = UIView()
            imagePlaceholder.backgroundColor = Design.Color.gray
            addSubview(imagePlaceholder)
            imagePlaceholder.translatesAutoresizingMaskIntoConstraints = false
            image = imagePlaceholder
        }

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            image.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.33),
            image.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 5 / 3)
        ])
    }

    private func configureShortInfoStack() {
        let stackView = UIStackView(
            arrangedSubviews: [nameLabel, specializationLabel, durationLabel, durationValueLabel]
        )
        stackView.spacing = 10
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: image.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -30),
            stackView.heightAnchor.constraint(equalTo: image.heightAnchor)
        ])
    }

    private func configureInfoLabel() {
        guard let infoText = doctor.info else { return }

        infoLabel.text = infoText
        addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: image.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        ])
    }
}
