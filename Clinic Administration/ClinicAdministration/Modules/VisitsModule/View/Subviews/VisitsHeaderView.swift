//
//  VisitsHeaderView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 21.12.2022.
//

import UIKit

final class VisitsHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        backgroundColor = Design.Color.chocolate
        layer.cornerRadius = Design.CornerRadius.large

        let label = UILabel()
        label.text = "Визиты"
        label.textColor = Design.Color.white
        label.font = Design.Font.robotoFont(ofSize: 24, weight: .bold)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20)
        ])
    }
}
