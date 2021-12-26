//
//  PatientDataView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 16.11.2021.
//

import UIKit

final class PatientDataView: UIView {
    private let firstNameTextField = FloatingTextField(placeholder: "Имя")
    private let secondNameTextField = FloatingTextField(placeholder: "Фамилия")
    private let patronymicNameTextField = FloatingTextField(placeholder: "Отчество")
    private let phoneNumberTextField = FloatingTextField(placeholder: "Номер телефона")

    var patientData: Patient? {
        Patient(
            secondName: secondNameTextField.text ?? "",
            firstName: firstNameTextField.text ?? "",
            patronymicName: patronymicNameTextField.text ?? "",
            phoneNumber: phoneNumberTextField.text ?? ""
        )
    }

    init(patient: Patient? = nil) {
        super.init(frame: .zero)

        if let patient = patient {
            firstNameTextField.text = patient.firstName
            secondNameTextField.text = patient.secondName
            patronymicNameTextField.text = patient.patronymicName
            phoneNumberTextField.text = patient.phoneNumber
        }

        let fieldsStack = UIStackView(arrangedSubviews: [
            firstNameTextField, secondNameTextField, patronymicNameTextField, phoneNumberTextField
        ])
        fieldsStack.axis = .vertical
        fieldsStack.distribution = .fillEqually
        fieldsStack.spacing = 10
        addSubview(fieldsStack)
        fieldsStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            fieldsStack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            fieldsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            fieldsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            fieldsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
