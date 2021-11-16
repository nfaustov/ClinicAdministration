//
//  PatientAppointmentOptionsView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 15.11.2021.
//

import UIKit

final class PatientAppointmentOptionsView: UIView {
    private enum FieldPosition {
        case top, bottom
    }

    private let calendar = Calendar.current

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter.shared
        formatter.dateFormat = "H:mm"
        return formatter
    }

    private let durationImage = UIImage(named: "clock")?.withTintColor(Design.Color.lightGray)

    private var doctorField: PatientAppointmentOptionField!
    private var dateField: PatientAppointmentOptionField!
    private var durationField: PatientAppointmentOptionField!
    private var timeField: PatientAppointmentOptionField!

    private let date: Date
    private let doctor: Doctor

    private var pickTimeAction: (() -> Void)?
    private var pickDurationAction: (() -> Void)?

    init(date: Date, doctor: Doctor, pickTimeAction: @escaping () -> Void, pickDurationAction: @escaping () -> Void) {
        self.pickTimeAction = pickTimeAction
        self.pickDurationAction = pickDurationAction
        self.date = date
        self.doctor = doctor
        super.init(frame: .zero)

        layer.backgroundColor = Design.Color.chocolate.cgColor
        layer.cornerRadius = 15
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        doctorField = PatientAppointmentOptionField(name: "Врач", value: doctor.initials)
        dateField = PatientAppointmentOptionField(name: "Дата", date: date)

        timeField = PatientAppointmentOptionField(name: "Время", value: dateFormatter.string(from: date))
        let timeTap = UITapGestureRecognizer(target: self, action: #selector(pickTime))
        timeField.addGestureRecognizer(timeTap)

        let durationValue = "\(doctor.serviceDuration / 60) мин"
        durationField = PatientAppointmentOptionField(name: "Длительность", value: durationValue, image: durationImage)
        let durationTap = UITapGestureRecognizer(target: self, action: #selector(pickDuration))
        durationField.addGestureRecognizer(durationTap)

        configureHorizontalFieldsStack(fields: [doctorField, dateField], position: .top)
        configureHorizontalFieldsStack(fields: [timeField, durationField], position: .bottom)
        configureHorizontalSeparator()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHorizontalFieldsStack(fields: [PatientAppointmentOptionField], position: FieldPosition) {
        let separator = UIView()
        separator.backgroundColor = Design.Color.darkGray

        let stackView = UIStackView(arrangedSubviews: fields)
        stackView.distribution = .fillEqually
        stackView.spacing = 12

        addSubview(stackView)
        addSubview(separator)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: position == .top ? topAnchor : centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: position == .top ? centerYAnchor : bottomAnchor),

            separator.centerXAnchor.constraint(equalTo: centerXAnchor),
            separator.bottomAnchor.constraint(equalTo: position == .top ? centerYAnchor : bottomAnchor, constant: -5),
            separator.widthAnchor.constraint(equalToConstant: 1),
            separator.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func configureHorizontalSeparator() {
        let separator = UIView()
        separator.backgroundColor = Design.Color.darkGray
        addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            separator.centerYAnchor.constraint(equalTo: centerYAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    @objc private func pickTime() {
        pickTimeAction?()
    }

    @objc private func pickDuration() {
        pickDurationAction?()
    }
}
