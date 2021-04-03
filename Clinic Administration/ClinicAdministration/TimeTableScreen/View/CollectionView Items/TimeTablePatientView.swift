//
//  TimeTablePatientView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 26.03.2021.
//

import UIKit
import Design

final class TimeTablePatientView: UIView {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 17, weight: .regular)
        label.textColor = Design.Color.white
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Font.robotoFont(ofSize: 17, weight: .light)
        label.textColor = Design.Color.white
        return label
    }()
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = Design.Color.gray
        return view
    }()

    init(secondName: String, firstName: String, patronymicName: String, phoneNumber: String) {
        super.init(frame: CGRect.zero)

        layer.backgroundColor = Design.Color.darkGray.cgColor
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = Design.Color.chocolate.cgColor
        layer.shadowOffset = .zero
        layer.shadowColor = Design.Color.darkGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10

        nameLabel.text = "\(secondName)\n\(firstName) \(patronymicName)"
        phoneNumberLabel.text = phoneNumber

        [nameLabel, separator, phoneNumberLabel].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),

            separator.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            separator.heightAnchor.constraint(equalToConstant: 1),

            phoneNumberLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 3),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            phoneNumberLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 5).cgPath
    }
}
