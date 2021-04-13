//
//  TimeTableCell.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 13.04.2021.
//

import Foundation

protocol TimeTableCell {
    associatedtype Model: Hashable

    static var reuseIdentifier: String { get }

    func configure(with: Model)
}
