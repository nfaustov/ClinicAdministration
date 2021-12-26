//
//  PatientAppointmentDataView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 20.12.2021.
//

import UIKit

final class PatientAppointmentDataView: UIView {
    private let doctor: Doctor
    private let date: Date
    private let scheduledTime: Date

    init(doctor: Doctor, date: Date, scheduledTime: Date) {
        self.doctor = doctor
        self.date = date
        self.scheduledTime = scheduledTime
        super.init(frame: .zero)

        layer.cornerRadius = Design.CornerRadius.large
        layer.masksToBounds = true

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        backgroundColor = Design.Color.chocolate

        let dateTitleLabel = UILabel()
        let timeTitleLabel = UILabel()
        let doctorTitleLabel = UILabel()
        let doctorLabel = UILabel()
        let timeLabel = UILabel()
        let dateLabel = Design.Label.dateLabel(date, ofSize: 18, textColor: Design.Color.lightGray)

        [dateTitleLabel, timeTitleLabel, doctorTitleLabel].forEach { label in
            label.font = Design.Font.robotoFont(ofSize: 13, weight: .regular)
            label.textColor = Design.Color.darkGray
        }

        dateTitleLabel.text = "Дата"
        timeTitleLabel.text = "Время"
        doctorTitleLabel.text = "Врач"

        [doctorLabel, timeLabel].forEach { label in
            label.font = Design.Font.robotoFont(ofSize: 18, weight: .regular)
            label.textColor = Design.Color.lightGray
        }

        doctorLabel.text = "\(doctor.fullName)"
        DateFormatter.shared.dateFormat = "H:mm"
        timeLabel.text = DateFormatter.shared.string(from: scheduledTime)

        let doctorSeparator = UIView()
        doctorSeparator.backgroundColor = Design.Color.brown
        let dateSeparator = UIView()
        dateSeparator.backgroundColor = Design.Color.brown

        [doctorSeparator, dateSeparator].forEach { separator in
            addSubview(separator)
            separator.translatesAutoresizingMaskIntoConstraints = false
        }

        let doctorStack = UIStackView(arrangedSubviews: [doctorTitleLabel, doctorLabel])
        let dateStack = UIStackView(arrangedSubviews: [dateTitleLabel, dateLabel])
        let timeStack = UIStackView(arrangedSubviews: [timeTitleLabel, timeLabel])

        [doctorStack, dateStack, timeStack].forEach { stack in
            stack.axis = .vertical
            stack.spacing = 5
            addSubview(stack)
            stack.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            doctorStack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            doctorStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            doctorStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),

            doctorSeparator.topAnchor.constraint(equalTo: doctorStack.bottomAnchor, constant: 5),
            doctorSeparator.leadingAnchor.constraint(equalTo: doctorStack.leadingAnchor),
            doctorSeparator.widthAnchor.constraint(equalTo: widthAnchor, constant: -40),
            doctorSeparator.heightAnchor.constraint(equalToConstant: 1),

            dateStack.topAnchor.constraint(equalTo: doctorSeparator.bottomAnchor, constant: 10),
            dateStack.leadingAnchor.constraint(equalTo: doctorStack.leadingAnchor),

            timeStack.topAnchor.constraint(equalTo: dateStack.topAnchor),
            timeStack.leadingAnchor.constraint(equalTo: dateStack.trailingAnchor, constant: 30),
            timeStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),

            dateSeparator.topAnchor.constraint(equalTo: dateStack.bottomAnchor, constant: 5),
            dateSeparator.leadingAnchor.constraint(equalTo: dateStack.leadingAnchor),
            dateSeparator.widthAnchor.constraint(equalTo: doctorSeparator.widthAnchor),
            dateSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
