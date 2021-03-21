//
//  DateFormatterExtension.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 17.01.2021.
//

import Foundation

extension DateFormatter {
    static let shared: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter
    }()
}
