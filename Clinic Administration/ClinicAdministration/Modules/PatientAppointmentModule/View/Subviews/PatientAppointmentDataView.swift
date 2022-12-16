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

    private var serviceDuration: Float
    private var maxSericeDuration: Float

    private var dateTitleLabel = Design.Label.titleLabel("Дата")
    private var timeTitleLabel = Design.Label.titleLabel("Время")
    private var doctorTitleLabel = Design.Label.titleLabel("Врач")
    private var durationTitleLabel = Design.Label.titleLabel("Длительность")

    private var durationLabel = Design.Label.valueLabel()
    private var doctorLabel = Design.Label.valueLabel()
    private var timeLabel = Design.Label.valueLabel()
    private var dateLabel: UILabel {
        Design.Label.dateLabel(date, ofSize: 18, textColor: Design.Color.lightGray)
    }

    private var durationSlider = UISlider()

    private var hoursTitle: String {
        let remainder = Int(durationSlider.value) / 60 % 10

        switch remainder {
        case 1: return "час"
        case 2, 3, 4: return "часа"
        default: return "часов"
        }
    }

    var duration: Double {
        Double(durationSlider.value * 60)
    }

    init(doctor: Doctor, date: Date, serviceDuration: Float, maxServiceDuration: Float) {
        self.doctor = doctor
        self.date = date
        self.serviceDuration = serviceDuration
        self.maxSericeDuration = maxServiceDuration

        super.init(frame: .zero)

        configureLabels()
        configureSlider()
        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLabels() {
        doctorLabel.text = "\(doctor.fullName)"
        DateFormatter.shared.dateFormat = "H:mm"
        timeLabel.text = DateFormatter.shared.string(from: date)
        durationLabel.text = adaptedTimeString(from: serviceDuration / 60)
    }

    private func configureSlider() {
        durationSlider.minimumTrackTintColor = Design.Color.lightGray
        durationSlider.maximumTrackTintColor = Design.Color.brown
        durationSlider.thumbTintColor = Design.Color.white
        durationSlider.minimumValue = Float(doctor.serviceDuration / 60)
        durationSlider.maximumValue = maxSericeDuration / 60
        durationSlider.value = serviceDuration / 60
        durationSlider.addTarget(self, action: #selector(slide), for: .valueChanged)
    }

    private func adaptedTimeString(from minutesValue: Float) -> String {
        let hours = Int(minutesValue) / 60
        let minutes = Int(minutesValue) % 60

        if hours >= 1 {
            return minutes == 0 ? "\(hours) \(hoursTitle)" : "\(hours) \(hoursTitle) \(minutes) минут"
        } else {
            return "\(minutes) минут"
        }
    }

    @objc private func slide() {
        let step = Float(doctor.serviceDuration / 60)
        let newStep = roundf(durationSlider.value / step)
        durationSlider.value = newStep * step
        durationLabel.text = adaptedTimeString(from: durationSlider.value)
    }

    private func configureHierarchy() {
        backgroundColor = Design.Color.chocolate

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
        let durationStack = UIStackView(arrangedSubviews: [durationTitleLabel, durationLabel, durationSlider])

        [doctorStack, dateStack, timeStack, durationStack].forEach { stack in
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
            timeStack.leadingAnchor.constraint(equalTo: dateStack.trailingAnchor, constant: 60),
            timeStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),

            dateSeparator.topAnchor.constraint(equalTo: dateStack.bottomAnchor, constant: 5),
            dateSeparator.leadingAnchor.constraint(equalTo: dateStack.leadingAnchor),
            dateSeparator.widthAnchor.constraint(equalTo: doctorSeparator.widthAnchor),
            dateSeparator.heightAnchor.constraint(equalToConstant: 1),

            durationStack.topAnchor.constraint(equalTo: dateSeparator.bottomAnchor, constant: 10),
            durationStack.leadingAnchor.constraint(equalTo: doctorStack.leadingAnchor),
            durationStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            durationStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20)
        ])
    }
}
