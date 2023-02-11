//
//  FloatingTextField.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 16.11.2021.
//

import UIKit

final class FloatingTextField: UIView {
    private let textField = UITextField()
    private let placeholderLabel = Label.light(ofSize: .titleMedium, color: Color.placeholderText)

    private var placeholderTopConstraint = NSLayoutConstraint()

    private var isEmpty: Bool {
        textField.text?.isEmpty ?? true
    }

    private let keyboardType: UIKeyboardType

    private var placeholder: String

    private var isActive: Bool {
        textField.isFirstResponder || !isEmpty
    }

    private var activity: Bool = false {
        didSet {
            guard activity != oldValue else { return }

            UIView.animate(withDuration: 0.15) {
                if self.activity {
                    let placeholderX = self.placeholderLabel.frame.width * 0.21
                    self.placeholderLabel.transform = .init(scaleX: 0.7, y: 0.7)
                        .translatedBy(x: -placeholderX, y: 0)
                    self.placeholderTopConstraint.constant = 0
                } else {
                    self.placeholderLabel.transform = .identity
                    self.placeholderTopConstraint.constant = 15
                }

                self.layoutIfNeeded()
            }
        }
    }

    var text: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
            activity = isActive
        }
    }

    init(placeholder: String, keyboardType: UIKeyboardType = .default) {
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        super.init(frame: .zero)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        textField.font = Font.titleMedium
        textField.textColor = Color.label
        textField.borderStyle = .none
        textField.autocapitalizationType = .words
        textField.keyboardType = keyboardType
        textField.delegate = self
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textRecognizer), for: .allEditingEvents)

        placeholderLabel.text = placeholder
        textField.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        let underline = UIView()
        underline.backgroundColor = Color.darkSeparator
        addSubview(underline)
        underline.translatesAutoresizingMaskIntoConstraints = false

        placeholderTopConstraint = placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 15),
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
        activity = isActive
    }
}

extension FloatingTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
