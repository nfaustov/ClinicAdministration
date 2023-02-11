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
        let label = Label.titleLarge(color: Color.label)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let specializationLabel: UILabel = {
        let label = Label.titleLarge(color: Color.secondaryLabel)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let durationLabel: UILabel = {
        let label = Label.titleLarge(color: Color.secondaryLabel)
        label.numberOfLines = 2
        return label
    }()
    private let infoLabel = Label.titleMedium(color: Color.secondaryLabel)

    var doctor: Doctor {
        didSet {
            subviews.forEach { $0.removeFromSuperview() }
            applyDoctor()
            layoutIfNeeded()
        }
    }

    init(doctor: Doctor) {
        self.doctor = doctor
        super.init(frame: .zero)

        backgroundColor = Color.secondaryBackground

        applyDoctor()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func applyDoctor() {
        configureImageView()
        configureShortInfoStack()
        configureInfoLabel()
    }

    private func configureImageView() {
        if let imageData = doctor.imageData, let photo = UIImage(data: imageData) {
            let imageView = UIImageView(image: photo)
            addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            image = imageView
        } else {
            let imagePlaceholder = UIView()
            imagePlaceholder.backgroundColor = Color.separator
            addSubview(imagePlaceholder)
            imagePlaceholder.translatesAutoresizingMaskIntoConstraints = false
            image = imagePlaceholder
        }

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            image.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.33),
            image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 4 / 3)
        ])
    }

    private func configureShortInfoStack() {
        nameLabel.text = doctor.fullName
        specializationLabel.text = doctor.specialization

        let durationText = "Длительность приема: "
        let durationValueText = "\(Int(doctor.serviceDuration / 60)) мин"
        let summaryDurationText = durationText + durationValueText
        let durationFont = Font.robotoFont(ofSize: .titleMedium, weight: .light)
        let durationValueFont = Font.robotoFont(ofSize: .titleMedium, weight: .regular)
        let attributedDurationText = NSMutableAttributedString(
            string: summaryDurationText,
            attributes: [NSAttributedString.Key.font: durationFont]
        )
        attributedDurationText.addAttribute(
            .font,
            value: durationValueFont,
            range: NSRange(location: durationText.count, length: durationValueText.count)
        )
        durationLabel.attributedText = attributedDurationText

        let stackView = UIStackView(
            arrangedSubviews: [nameLabel, specializationLabel, durationLabel]
        )
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.setCustomSpacing(30, after: specializationLabel)
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
            infoLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -70)
        ])
    }
}
