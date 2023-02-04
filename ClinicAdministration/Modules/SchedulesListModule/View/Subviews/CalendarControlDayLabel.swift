//
//  CalendarControlDayLabel.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.10.2021.
//

import UIKit
import HorizonCalendar

struct CalendarControlDayLabel: CalendarItemViewRepresentable {
    struct InvariantViewProperties: Hashable {
        let font: UIFont
        var textColor: UIColor
        var backgroundColor: UIColor
        var borderColor: UIColor
    }

    struct ViewModel: Equatable {
        let day: Day
    }

    static func makeView(withInvariantViewProperties invariantViewProperties: InvariantViewProperties) -> UILabel {
        let label = UILabel()

        label.font = invariantViewProperties.font
        label.textColor = invariantViewProperties.textColor
        label.backgroundColor = invariantViewProperties.backgroundColor
        label.layer.borderColor = invariantViewProperties.borderColor.cgColor
        label.layer.borderWidth = 1

        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = Design.CornerRadius.small

        return label
    }

    static func setViewModel(_ viewModel: ViewModel, on view: UILabel) {
        view.text = "\(viewModel.day.day)"
    }
}
