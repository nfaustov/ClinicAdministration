//
//  SchedulePicker.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 27.04.2021.
//

import UIKit

final class SchedulePicker: UIView {
    private let doctorFieldLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 13, weight: .regular)
        label.textColor = Design.Color.darkGray
        label.text = "Врач"
        return label
    }()
    private let doctorLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 18, weight: .regular)
        label.textColor = Design.Color.white
        label.text = "Выберите врача"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let datefieldLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 13, weight: .regular)
        label.textColor = Design.Color.darkGray
        label.text = "Дата"
        return label
    }()

    private let monthLabel = UILabel()
    private let dayLabel = UILabel()
    private let weekdayLabel = UILabel()

    private let topSeparator = UIView()

    private let calendarImageView = UIImageView(
        image: UIImage(named: "calendar")?.withTintColor(Design.Color.lightGray)
    )
    private let doctorImageView = UIImageView(
        image: UIImage(named: "chevron_down")?.withTintColor(Design.Color.lightGray)
    )

    private let dateStack = UIStackView()
    private let fieldNamesStack = UIStackView()

    private let dateButton = UIButton()
    private let doctorButton = UIButton()

    private let calendar = Calendar.current

    var date: Date {
        didSet {
            configureDateLabels()
        }
    }

    private var calendarAction: (() -> Void)?
    private var doctorAction: (() -> Void)?

    init(date: Date, calendarAction: @escaping () -> Void, doctorAction: @escaping () -> Void) {
        self.calendarAction = calendarAction
        self.doctorAction = doctorAction
        self.date = date
        super.init(frame: .zero)

        layer.backgroundColor = Design.Color.chocolate.cgColor
        layer.cornerRadius = 15
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        configureDateLabels()
        configureFieldNamesStack()
        configureFields()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureFieldNamesStack() {
        fieldNamesStack.addArrangedSubview(doctorFieldLabel)
        fieldNamesStack.addArrangedSubview(datefieldLabel)
        fieldNamesStack.distribution = .fillEqually
        addSubview(fieldNamesStack)

        fieldNamesStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            fieldNamesStack.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            fieldNamesStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            fieldNamesStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
        ])
    }

    private func configureFields() {
        let calendarTap = UITapGestureRecognizer(target: self, action: #selector(pickDate))
        dateButton.addGestureRecognizer(calendarTap)

        let doctorTap = UIGestureRecognizer(target: self, action: #selector(pickDoctor))
        doctorButton.addGestureRecognizer(doctorTap)

        for view in [
            doctorLabel,
            doctorImageView,
            topSeparator,
            dateStack,
            calendarImageView,
            doctorButton,
            dateButton
        ] {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        topSeparator.backgroundColor = Design.Color.darkGray

        dateStack.addArrangedSubview(monthLabel)
        dateStack.addArrangedSubview(dayLabel)
        dateStack.addArrangedSubview(weekdayLabel)
        dateStack.spacing = 4
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            doctorLabel.topAnchor.constraint(equalTo: fieldNamesStack.bottomAnchor, constant: 6),
            doctorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            doctorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),

            doctorImageView.centerYAnchor.constraint(equalTo: doctorLabel.centerYAnchor),
            doctorImageView.heightAnchor.constraint(equalToConstant: 16),
            doctorImageView.widthAnchor.constraint(equalTo: doctorImageView.heightAnchor),
            doctorImageView.leadingAnchor.constraint(greaterThanOrEqualTo: doctorLabel.trailingAnchor, constant: 8),
            doctorImageView.trailingAnchor.constraint(equalTo: topSeparator.leadingAnchor, constant: -8),

            topSeparator.centerXAnchor.constraint(equalTo: centerXAnchor),
            topSeparator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            topSeparator.widthAnchor.constraint(equalToConstant: 1),
            topSeparator.heightAnchor.constraint(equalToConstant: 20),

            dateStack.centerYAnchor.constraint(equalTo: doctorLabel.centerYAnchor),
            dateStack.leadingAnchor.constraint(equalTo: topSeparator.trailingAnchor, constant: 8),

            calendarImageView.centerYAnchor.constraint(equalTo: doctorLabel.centerYAnchor),
            calendarImageView.heightAnchor.constraint(equalToConstant: 22),
            calendarImageView.widthAnchor.constraint(equalTo: calendarImageView.heightAnchor),
            calendarImageView.leadingAnchor.constraint(greaterThanOrEqualTo: dateStack.trailingAnchor, constant: 10),
            calendarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            doctorButton.topAnchor.constraint(equalTo: doctorLabel.topAnchor),
            doctorButton.leadingAnchor.constraint(equalTo: doctorLabel.leadingAnchor),
            doctorButton.trailingAnchor.constraint(equalTo: doctorImageView.trailingAnchor),
            doctorButton.bottomAnchor.constraint(equalTo: doctorLabel.bottomAnchor),

            dateButton.topAnchor.constraint(equalTo: dateStack.topAnchor),
            dateButton.leadingAnchor.constraint(equalTo: dateStack.leadingAnchor),
            dateButton.trailingAnchor.constraint(equalTo: calendarImageView.trailingAnchor),
            dateButton.bottomAnchor.constraint(equalTo: dateStack.bottomAnchor)
        ])
    }

    private func configureDateLabels() {
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

    @objc private func pickDate() {
        calendarAction?()
    }

    @objc private func pickDoctor() {
        doctorAction?()
    }
}
