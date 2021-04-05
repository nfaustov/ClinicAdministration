//
//  CallButtonFooter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 01.04.2021.
//

import UIKit
import Design

final class CallButtonFooter: UICollectionReusableView {
    static let reuseIdentifier = "CallButtonFooter"

    override init(frame: CGRect) {
        super.init(frame: frame)

        let button = UIButton()
        button.setTitle("СВЯЗАТЬСЯ С ВРАЧОМ", for: .normal)
        button.setTitleColor(Design.Color.white, for: .normal)
        button.backgroundColor = Design.Color.red
        button.layer.cornerRadius = Design.CornerRadius.medium
        button.titleEdgeInsets.left = -70
        addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
