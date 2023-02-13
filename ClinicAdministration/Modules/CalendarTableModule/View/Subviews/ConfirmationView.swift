//
//  ConfirmationView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 15.12.2020.
//

import UIKit

final class ConfirmationView: UIView {
    private let separatorView = UIView()
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color.fill
        button.setTitle("ГОТОВО", for: .normal)
        button.titleLabel?.font = Font.titleMedium
        button.setTitleColor(Color.lightLabel, for: .normal)
        button.layer.cornerRadius = Design.CornerRadius.small
        return button
    }()
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color.background
        button.setTitle("ОТМЕНИТЬ", for: .normal)
        button.titleLabel?.font = Font.titleMedium
        button.setTitleColor(Color.secondaryLabel, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = Color.secondaryLabel.cgColor // .style(.secondaryLabel).cgColor
        button.layer.cornerRadius = Design.CornerRadius.small
        return button
    }()
    private let dateLabel: UILabel = {
        let label = Label.titleMedium(color: Color.label)
        label.numberOfLines = 2
        return label
    }()

    var dateText: String = " " {
        didSet {
            dateLabel.text = dateText
            setNeedsLayout()
        }
    }

    var cancelAction: (() -> Void)?
    var confirmAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
    }

    private func configureHierarchy() {
        backgroundColor = Color.secondaryBackground

        separatorView.backgroundColor = Color.separator

        for view in [separatorView, dateLabel, cancelButton, confirmButton] {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),

            cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            cancelButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),

            confirmButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 16),
            confirmButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor),
            confirmButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func cancel() {
        cancelAction?()
    }

    @objc private func confirm() {
        confirmAction?()
    }
}
