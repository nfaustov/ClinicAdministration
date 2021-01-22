//
//  MonthHeader.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 14.12.2020.
//

import UIKit
import HorizonCalendar

struct MonthHeader: CalendarItemViewRepresentable {

    struct InvariantViewProperties: Hashable {
        let font: UIFont
        let textColor: UIColor
        let backgoundColor: UIColor
    }

    struct ViewModel: Equatable {
        let month: Month
    }

    static func makeView(withInvariantViewProperties invariantViewProperties: InvariantViewProperties) -> UILabel {
        let label = UILabel()

        label.font = invariantViewProperties.font
        label.textColor = invariantViewProperties.textColor
        label.backgroundColor = invariantViewProperties.backgoundColor

        return label
    }

    static func setViewModel(_ viewModel: ViewModel, on view: UILabel) {
        let calendar = Calendar.current
        DateFormatter.shared.dateFormat = "LLLL"

        guard let date = calendar.date(from: viewModel.month.components) else { return }

        view.text = DateFormatter.shared.string(from: date).capitalized
    }
}
