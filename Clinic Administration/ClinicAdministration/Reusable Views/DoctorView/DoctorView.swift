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
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let specializationLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 18, weight: .light)
        label.textColor = Design.Color.brown
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let durationLabel: UILabel = {
        let label = UILabel()
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

    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Выбрать другого врача", for: .normal)
        button.setTitleColor(Design.Color.chocolate, for: .normal)
        button.titleLabel?.font = Design.Font.robotoFont(ofSize: 15, weight: .medium)
        button.backgroundColor = Design.Color.white
        button.layer.cornerRadius = Design.CornerRadius.small
        button.layer.shadowColor = Design.Color.brown.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.2
        return button
    }()

    private var doctor: Doctor

    private var pickDoctorAction: (() -> Void)?

    init(doctor: Doctor, pickDoctorAction: @escaping () -> Void) {
        self.doctor = doctor
        self.pickDoctorAction = pickDoctorAction
        super.init(frame: .zero)

        backgroundColor = Design.Color.white

        configureImageView()
        configureShortInfoStack()
        configureInfoLabel()
        configureButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        button.layer.shadowPath = UIBezierPath(
            roundedRect: button.bounds,
            cornerRadius: button.layer.cornerRadius
        ).cgPath
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
            image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 4 / 3)
        ])
    }

    private func configureShortInfoStack() {
        nameLabel.text = doctor.fullName
        specializationLabel.text = doctor.specialization

        let durationText = "Длительность приема: "
        let durationValueText = "\(Int(doctor.serviceDuration / 60)) мин"
        let summaryDurationText = durationText + durationValueText
        let durationFont = Design.Font.robotoFont(ofSize: 16, weight: .light)
        let durationValueFont = Design.Font.robotoFont(ofSize: 16, weight: .regular)
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

    private func configureButton() {
        button.addTarget(self, action: #selector(pickDoctor), for: .touchUpInside)
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc private func pickDoctor() {
        pickDoctorAction?()
    }
}
