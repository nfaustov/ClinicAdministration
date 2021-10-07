//
//  CreateScheduleCell.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 11.06.2021.
//

import Foundation

protocol CreateScheduleCell {
    associatedtype Model: Hashable
    static var reuseIndentifier: String { get }

    func configure(with: Model)
}
