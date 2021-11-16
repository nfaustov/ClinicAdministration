//
//  PatientAppointmentOptionField.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 16.11.2021.
//

import UIKit

final class PatientAppointmentOptionField: UIView {
    enum ImageType {
        case custom, standard
    }

    let fieldNameLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 13, weight: .regular)
        label.textColor = Design.Color.darkGray
        return label
    }()
    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 18, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let monthLabel = UILabel()
    private let dayLabel = UILabel()
    private let weekdayLabel = UILabel()

    private let dateStack = UIStackView()
    private var imageView: UIImageView?
    private let imageSize: CGFloat

    var text: String! {
        didSet {
            valueLabel.text = text
        }
    }

    init(name: String, value: String, image: UIImage? = UIImage(named: "chevron_down")) {
        imageSize = image == UIImage(named: "chevron_down") ? 16 : 22
        imageView = image != nil ? UIImageView(image: image) : nil
        super.init(frame: .zero)

        fieldNameLabel.text = name
        valueLabel.text = value
        valueLabel.textColor = image != nil ? Design.Color.white : Design.Color.gray

        for view in [fieldNameLabel, valueLabel, imageView].compactMap({ $0 }) {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        setupConstaints(valueView: valueLabel)
    }

    init(name: String, date: Date) {
        imageSize = 0
        super.init(frame: .zero)

        fieldNameLabel.text = name

        configureDateLabels(with: date)

        dateStack.addArrangedSubview(monthLabel)
        dateStack.addArrangedSubview(dayLabel)
        dateStack.addArrangedSubview(weekdayLabel)
        dateStack.spacing = 4

        for view in [fieldNameLabel, dateStack] {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        setupConstaints(valueView: dateStack)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureDateLabels(with date: Date) {
        DateFormatter.shared.dateFormat = "LLL d EE"

        let stringDate = DateFormatter.shared.string(from: date)
        let splitDate = stringDate.split(separator: " ")
        let month = "\(splitDate[0].capitalized.replacingOccurrences(of: ".", with: ""))"
        let day = "\(splitDate[1])"
        let weekday = "\(splitDate[2])"

        monthLabel.text = month
        monthLabel.textColor = Design.Color.gray
        monthLabel.font = Design.Font.robotoFont(ofSize: 18, weight: .medium)

        dayLabel.text = day
        dayLabel.textColor = Design.Color.gray
        dayLabel.font = Design.Font.robotoFont(ofSize: 18, weight: .regular)

        weekdayLabel.text = weekday
        weekdayLabel.textColor = Design.Color.gray
        weekdayLabel.font = Design.Font.robotoFont(ofSize: 18, weight: .light)
    }

    private func setupConstaints(valueView: UIView) {
        NSLayoutConstraint.activate([
            fieldNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            fieldNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            valueView.topAnchor.constraint(equalTo: fieldNameLabel.bottomAnchor, constant: 6),
            valueView.leadingAnchor.constraint(equalTo: fieldNameLabel.leadingAnchor),
            valueView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])

        guard let imageView = imageView else { return }

        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: valueView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: imageSize),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: valueView.trailingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
