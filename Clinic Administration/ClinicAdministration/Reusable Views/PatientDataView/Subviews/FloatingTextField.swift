//
//  FloatingTextField.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 16.11.2021.
//

import UIKit

final class FloatingTextField: UIView {
    private let textField = UITextField()
    private let placeholderLabel = UILabel()

    private var escapedPlaceholderFont: UIFont {
        Design.Font.robotoFont(ofSize: 13, weight: .light)
    }
    private var placeholderFont: UIFont {
        Design.Font.robotoFont(ofSize: 17, weight: .light)
    }

    private var placeholderTopConstraint = NSLayoutConstraint()

    private var isEmpty: Bool {
        textField.text?.isEmpty ?? true
    }

    private var placeholder: String

    var text: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
        }
    }

    init(placeholder: String) {
        self.placeholder = placeholder
        super.init(frame: .zero)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        textField.font = Design.Font.robotoFont(ofSize: 17, weight: .regular)
        textField.textColor = Design.Color.chocolate
        textField.borderStyle = .none
        textField.autocapitalizationType = .words
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textRecognizer), for: .allEditingEvents)

        placeholderLabel.text = placeholder
        placeholderLabel.textColor = Design.Color.darkGray
        placeholderLabel.font = placeholderFont
        textField.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        let underline = UIView()
        underline.backgroundColor = Design.Color.darkGray
        addSubview(underline)
        underline.translatesAutoresizingMaskIntoConstraints = false

        placeholderTopConstraint = placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),

            placeholderTopConstraint,
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            placeholderLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),

            underline.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            underline.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            underline.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    @objc private func textRecognizer() {
        let isActive = textField.isFirstResponder || !isEmpty

        UIView.animate(withDuration: 0.15) {
            self.placeholderLabel.font = isActive ? self.escapedPlaceholderFont : self.placeholderFont
            self.placeholderTopConstraint.constant = isActive ? 0 : 10
            self.layoutIfNeeded()
        }
    }
}

extension FloatingTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
