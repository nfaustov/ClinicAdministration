//
//  DateFormatterExtension.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 17.01.2021.
//

import Foundation

extension DateFormatter {
    static let shared: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        return df
    }()
}
