//
//  CalendarControlDayOfWeekRow.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.10.2021.
//

import UIKit
import HorizonCalendar

struct CalendarControlDayOfWeekRow: CalendarItemViewRepresentable {
    struct InvariantViewProperties: Hashable {
        let label: UILabel
        let backgroundColor: UIColor
    }

    struct ViewModel: Equatable {
        var dayOfWeekIndex: Int
    }

    static func makeView(withInvariantViewProperties invariantViewProperties: InvariantViewProperties) -> UILabel {
        let label = invariantViewProperties.label
        label.backgroundColor = invariantViewProperties.backgroundColor
        label.textAlignment = .center

        return label
    }

    static func setViewModel(_ viewModel: ViewModel, on view: UILabel) {
        for index in 0...viewModel.dayOfWeekIndex {
            view.text = DateFormatter.shared.shortWeekdaySymbols[index]
        }
    }
}
