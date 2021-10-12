//
//  DoctorViewCell.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 11.06.2021.
//

import UIKit

final class DoctorViewCell: UICollectionViewCell, SelfConfiguredCell {
    static let reuseIdentifier: String = "DoctorViewCell"

    func configure(with doctor: Doctor) {
        let doctorView = DoctorView(doctor: doctor)
        addSubview(doctorView)
        doctorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            doctorView.topAnchor.constraint(equalTo: topAnchor),
            doctorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            doctorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            doctorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
