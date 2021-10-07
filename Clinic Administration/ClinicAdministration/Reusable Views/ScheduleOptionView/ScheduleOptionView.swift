//
//  ScheduleOptionView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 10.06.2021.
//

import UIKit

class ScheduleOptionView: UIView {
    private let imageView = UIImageView()
    private let dateStack = UIStackView()

    private let monthLabel = UILabel()
    private let dayLabel = UILabel()
    private let weekdayLabel = UILabel()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 13, weight: .regular)
        label.textColor = Design.Color.darkGray
        return label
    }()
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 18, weight: .regular)
        label.textColor = Design.Color.white
        return label
    }()

    private let imageSize: CGFloat

    var value: String! {
        didSet {
            valueLabel.text = value
        }
    }
    var date: Date! {
        didSet {
            configureDateLabels(with: date)
        }
    }

    init(title: String, valuePlaceholder: String) {
        imageSize = 16
        super.init(frame: .zero)

        titleLabel.text = title
        valueLabel.text = valuePlaceholder
        imageView.image = UIImage(named: "chevron_down")?.withTintColor(Design.Color.lightGray)

        configureHierarchy(with: valueLabel)
    }

    init(title: String, date: Date) {
        imageSize = 22
        super.init(frame: .zero)

        titleLabel.text = title
        imageView.image = UIImage(named: "calendar")?.withTintColor(Design.Color.lightGray)

        configureHierarchy(with: dateStack)
        configureDateLabels(with: date)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }

    private func configureHierarchy(with valueView: UIView) {
        layer.backgroundColor = Design.Color.chocolate.cgColor
        layer.cornerRadius = Design.CornerRadius.large
        layer.shadowColor = Design.Color.brown.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8

        [titleLabel, valueView, imageView].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            valueView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            valueView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            valueView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -4),

            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: imageSize),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: valueView.trailingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    private func configureDateLabels(with date: Date) {
        DateFormatter.shared.dateFormat = "LLLL d EEEE"
        let stringDate = DateFormatter.shared.string(from: date)
        let splitDate = stringDate.split(separator: " ")
        let month = "\(splitDate[0].capitalized.replacingOccurrences(of: ".", with: ""))"
        let day = "\(splitDate[1])"
        let weekday = "\(splitDate[2])"

        configureDateLabel(monthLabel, text: month, fontWeight: .medium)
        configureDateLabel(dayLabel, text: day, fontWeight: .regular)
        configureDateLabel(weekdayLabel, text: weekday, fontWeight: .light)

        [monthLabel, dayLabel, weekdayLabel].forEach { label in
            dateStack.addArrangedSubview(label)
        }
        dateStack.spacing = 4
    }

    private func configureDateLabel(_ label: UILabel, text: String, fontWeight: Design.RobotoFontWeight) {
        label.text = text
        label.textColor = Design.Color.white
        label.font = Design.Font.robotoFont(ofSize: 18, weight: fontWeight)
    }
}
