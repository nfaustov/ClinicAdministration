//
//  DateFormatterExtension.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 17.01.2021.
//

import Foundation

public extension DateFormatter {
    /// The shared date formatter object with "ru_RU" locale
    static let shared: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter
    }()
}
