//
//  SchedulePickerField.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 29.04.2021.
//

import UIKit

final class SchedulePickerField: UIView {
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
        label.textColor = Design.Color.white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let monthLabel = UILabel()
    private let dayLabel = UILabel()
    private let weekdayLabel = UILabel()

    private let imageView = UIImageView()
    private let dateStack = UIStackView()

    private let imageSize: CGFloat

    var text: String! {
        didSet {
            valueLabel.text = text
        }
    }
    var date: Date! {
        didSet {
            configureDateLabels(with: date)
        }
    }

    init(name: String, placeholder: String, image: UIImage? = UIImage(named: "chevron_down")) {
        imageSize = image == UIImage(named: "chevron_down") ? 16 : 22
        super.init(frame: .zero)

        fieldNameLabel.text = name
        valueLabel.text = placeholder
        imageView.image = image?.withTintColor(Design.Color.lightGray)

        for view in [fieldNameLabel, valueLabel, imageView] {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        setupConstaints(dynamicView: valueLabel)
    }

    init(name: String, date: Date) {
        imageSize = 22
        super.init(frame: .zero)

        fieldNameLabel.text = name
        imageView.image = UIImage(named: "calendar")?.withTintColor(Design.Color.lightGray)

        configureDateLabels(with: date)

        dateStack.addArrangedSubview(monthLabel)
        dateStack.addArrangedSubview(dayLabel)
        dateStack.addArrangedSubview(weekdayLabel)
        dateStack.spacing = 4

        for view in [fieldNameLabel, dateStack, imageView] {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        setupConstaints(dynamicView: dateStack)
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
        monthLabel.textColor = Design.Color.white
        monthLabel.font = Design.Font.robotoFont(ofSize: 18, weight: .medium)

        dayLabel.text = day
        dayLabel.textColor = Design.Color.white
        dayLabel.font = Design.Font.robotoFont(ofSize: 18, weight: .regular)

        weekdayLabel.text = weekday
        weekdayLabel.textColor = Design.Color.white
        weekdayLabel.font = Design.Font.robotoFont(ofSize: 18, weight: .light)
    }

    private func setupConstaints(dynamicView: UIView) {
        NSLayoutConstraint.activate([
            fieldNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            fieldNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            dynamicView.topAnchor.constraint(equalTo: fieldNameLabel.bottomAnchor, constant: 6),
            dynamicView.leadingAnchor.constraint(equalTo: fieldNameLabel.leadingAnchor),
            dynamicView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),

            imageView.centerYAnchor.constraint(equalTo: dynamicView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: imageSize),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: dynamicView.trailingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
