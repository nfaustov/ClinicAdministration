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

    private var scale: CGFloat {
        escapedPlaceholderSize / placeholderSize
    }

    private var escapedPlaceholderSize: CGFloat = 14
    private var placeholderSize: CGFloat = 17

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
        textField.font = Design.Font.robotoFont(ofSize: placeholderSize, weight: .regular)
        textField.textColor = Design.Color.chocolate
        textField.borderStyle = .none
        textField.autocapitalizationType = .words
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textRecognizer), for: .allEditingEvents)

        placeholderLabel.text = placeholder
        placeholderLabel.textColor = Design.Color.darkGray
        placeholderLabel.font = Design.Font.robotoFont(ofSize: placeholderSize, weight: .light)
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
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeholderLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),

            underline.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            underline.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 1),
            underline.widthAnchor.constraint(equalToConstant: 1)
        ])
    }

    @objc private func textRecognizer() {
        let isActive = textField.isFirstResponder || !isEmpty

        let transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

        UIView.animate(withDuration: 0.2) {
            self.placeholderLabel.transform = isActive ? transform : .identity
            self.placeholderTopConstraint.constant = 0
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
