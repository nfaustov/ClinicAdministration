//
//  ScheduleOptionView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 10.06.2021.
//

import UIKit

class ScheduleOptionView: UIView {
    private let imageView = UIImageView()

    private let titleLabel = Label.labelLarge(color: Design.Color.darkGray)
    private var dateLabel: UILabel?
    private var valueLabel: UILabel?

    private let imageSize: CGFloat

    var value: String? {
        didSet {
            valueLabel?.text = value
        }
    }
    var date: Date? {
        didSet {
            guard let date = date else { return }

            dateLabel = Label.dateLabel(date, ofSize: .titleLarge, textColor: Design.Color.white)
        }
    }

    init(title: String, valuePlaceholder: String) {
        imageSize = 16
        super.init(frame: .zero)

        titleLabel.text = title
        valueLabel = Label.titleLarge(color: Design.Color.white, withText: valuePlaceholder)
        imageView.image = UIImage(named: "chevron_down")?.withTintColor(Design.Color.lightGray)

        configureHierarchy(with: valueLabel)
    }

    init(title: String, date: Date) {
        imageSize = 22
        super.init(frame: .zero)

        titleLabel.text = title
        imageView.image = UIImage(named: "calendar")?.withTintColor(Design.Color.lightGray)

        dateLabel = Label.dateLabel(date, ofSize: .titleLarge, textColor: Design.Color.white)
        configureHierarchy(with: dateLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy(with valueView: UIView?) {
        guard let valueView = valueView else { return }

        layer.backgroundColor = Design.Color.chocolate.cgColor
        layer.cornerRadius = Design.CornerRadius.large

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
}
