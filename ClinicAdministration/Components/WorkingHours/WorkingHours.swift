//
//  WorkingHours.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 11.10.2021.
//

import Foundation

final class WorkingHours {
    let opening: Date
    let close: Date

    private let calendar = Calendar.current

    init(date: Date) {
        let dateComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
        var opening = dateComponents
        var close = dateComponents

        switch dateComponents.weekday {
        case 1:
            opening.hour = 9
            close.hour = 15
        case 7:
            opening.hour = 9
            close.hour = 18
        default:
            opening.hour = 8
            close.hour = 19
        }

        self.opening = calendar.date(from: opening) ?? Date()
        self.close = calendar.date(from: close) ?? Date()
    }
}
