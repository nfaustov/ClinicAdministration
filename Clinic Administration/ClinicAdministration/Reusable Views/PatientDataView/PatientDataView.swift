//
//  PatientDataView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 16.11.2021.
//

import UIKit

final class PatientDataView: UIView {
    init(patient: Patient? = nil) {
        super.init(frame: .zero)

        let firstNameTextField = FloatingTextField(placeholder: "Имя")
        let secondNameTextField = FloatingTextField(placeholder: "Фамилия")
        let patronymicNameTextField = FloatingTextField(placeholder: "Отчество")
        let phoneNumberTextField = FloatingTextField(placeholder: "Номер телефона")

        if let patient = patient {
            firstNameTextField.text = patient.firstName
            secondNameTextField.text = patient.secondName
            patronymicNameTextField.text = patient.patronymicName
            phoneNumberTextField.text = patient.phoneNumber
        }

        let fieldsStack = UIStackView(arrangedSubviews: [
            firstNameTextField, secondNameTextField, patronymicNameTextField, phoneNumberTextField
        ])
        fieldsStack.spacing = 10
        addSubview(fieldsStack)
        fieldsStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            fieldsStack.topAnchor.constraint(equalTo: topAnchor),
            fieldsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            fieldsStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            fieldsStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
