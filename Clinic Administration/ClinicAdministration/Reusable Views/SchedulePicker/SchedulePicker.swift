//
//  SchedulePicker.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 27.04.2021.
//

import UIKit

protocol SchedulePickerDelegate: AnyObject {
    func pickDate()
    func pickDoctor()
    func pickTimeInterval()
    func pickCabinet()
}

final class SchedulePicker: UIView {
    enum FieldPosition {
        case top, bottom
    }

    private let intervalImage = UIImage(named: "clock")?.withTintColor(Design.Color.lightGray)

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter.shared
        formatter.dateFormat = "H:mm"
        return formatter
    }
    private let calendar = Calendar.current

    private var doctorField: SchedulePickerField!
    private var dateField: SchedulePickerField!
    private var intervalField: SchedulePickerField!
    private var cabinetField: SchedulePickerField!

    var cabinet: Int! {
        didSet {
            guard let cabinet = cabinet else { return }

            cabinetField.text = "\(cabinet)"
        }
    }
    var doctor: Doctor! {
        didSet {
            guard let firstNameLetter = doctor.firstName.first,
                  let patronymicNameLetter = doctor.patronymicName.first else { return }

            doctorField.text = "\(doctor.secondName) \(firstNameLetter).\(patronymicNameLetter)."
        }
    }
    var interval: (Date, Date)! {
        didSet {
            intervalField.text = dateFormatter.string(from: interval.0) + " - " + dateFormatter.string(from: interval.1)
        }
    }
    var date: Date! {
        didSet {
            dateField.date = date
        }
    }

    weak var delegate: SchedulePickerDelegate?

    init(date: Date) {
        super.init(frame: .zero)

        layer.backgroundColor = Design.Color.chocolate.cgColor
        layer.cornerRadius = 15
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        doctorField = SchedulePickerField(name: "Врач", placeholder: "Выберите врача")
        let doctorTap = UITapGestureRecognizer(target: self, action: #selector(pickDoctor))
        doctorField.addGestureRecognizer(doctorTap)

        dateField = SchedulePickerField(name: "Дата", date: date)
        let dateTap = UITapGestureRecognizer(target: self, action: #selector(pickDate))
        dateField.addGestureRecognizer(dateTap)

        intervalField = SchedulePickerField(name: "Время приема", placeholder: "... - ...", image: intervalImage)
        let intervalTap = UITapGestureRecognizer(target: self, action: #selector(pickInterval))
        intervalField.addGestureRecognizer(intervalTap)

        cabinetField = SchedulePickerField(name: "Кабинет", placeholder: "Выберите кабинет")
        let cabinetTap = UITapGestureRecognizer(target: self, action: #selector(pickCabinet))
        cabinetField.addGestureRecognizer(cabinetTap)

        configureHorizontalFieldsStack(fields: [doctorField, dateField], position: .top)
        configureHorizontalFieldsStack(fields: [intervalField, cabinetField], position: .bottom)
        configureHorizontalSeparator()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHorizontalFieldsStack(fields: [SchedulePickerField], position: FieldPosition) {
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

    @objc private func pickDate() {
        delegate?.pickDate()
    }

    @objc private func pickDoctor() {
        delegate?.pickDoctor()
    }

    @objc private func pickInterval() {
        delegate?.pickTimeInterval()
    }

    @objc private func pickCabinet() {
        delegate?.pickCabinet()
    }
}
