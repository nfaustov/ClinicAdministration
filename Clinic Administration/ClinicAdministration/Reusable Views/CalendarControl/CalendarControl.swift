//
//  CalendarControl.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.10.2021.
//

import UIKit
import HorizonCalendar

protocol CalendarControlDelegate: AnyObject {
    func didSelectedDate(_ date: Date)
    func didSelectedInterval(_ interval: DateInterval)
}

extension CalendarControlDelegate {
    func didSelectedInterval(interval: DateInterval) {
    }
}

final class CalendarControl: UIView {
    private let calendar = Calendar.current

    private var selectedDay: Day?

    weak var delegate: CalendarControlDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureCalendar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureCalendar() {
        let calendarView = CalendarView(initialContent: makeContent())
        calendarView.backgroundColor = Design.Color.chocolate
        addSubview(calendarView)

        calendarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        calendarView.daySelectionHandler = { [weak self] day in
            guard let self = self else { return }

            if self.compareToNow(day) != .orderedAscending {
                self.selectedDay = day

                guard let components = self.selectedDay?.components,
                      let pickedDate = self.calendar.date(from: components) else { return }

                self.delegate?.didSelectedDate(pickedDate)
            }

            let newContent = self.makeContent()
            calendarView.setContent(newContent)
        }
    }

    private func makeContent() -> CalendarViewContent {
        let endDate = Date(timeInterval: 60 * 60 * 24 * 365, since: Date())

        let selectedDay = self.selectedDay

        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: Date()...endDate,
            monthsLayout: .horizontal(
                options: HorizontalMonthsLayoutOptions(
                    maximumFullyVisibleMonths: 1,
                    scrollingBehavior: .freeScrolling
                )
            )
        )
            .withDayItemModelProvider { day in
                var invariantViewProperties = CalendarControlDayLabel.InvariantViewProperties(
                    font: Design.Font.robotoFont(ofSize: 19, weight: .regular),
                    textColor: Design.Color.gray,
                    backgroundColor: .clear
                )

                if day == selectedDay {
                    invariantViewProperties.textColor = Design.Color.brown
                    invariantViewProperties.backgroundColor = Design.Color.lightGray
                }

                if self.compareToNow(day) == .orderedAscending {
                    invariantViewProperties.textColor = Design.Color.darkGray
                }

                return CalendarItemModel<CalendarControlDayLabel>(
                    invariantViewProperties: invariantViewProperties,
                    viewModel: .init(day: day)
                )
            }
            .withMonthHeaderItemModelProvider { month in
                CalendarItemModel<CalendarControlMonthHeader>(
                    invariantViewProperties: .init(
                        font: Design.Font.robotoFont(ofSize: 22, weight: .medium),
                        textColor: Design.Color.lightGray,
                        backgroundColor: .clear
                    ),
                    viewModel: .init(month: month)
                )
            }
            .withDayOfWeekItemModelProvider { _, dayOfWeekIndex in
                CalendarItemModel<CalendarControlDayOfWeekRow>(
                    invariantViewProperties: .init(
                        font: Design.Font.robotoFont(ofSize: 16, weight: .regular),
                        textColor: Design.Color.darkGray,
                        backgroundColor: .clear
                    ),
                    viewModel: .init(dayOfWeekIndex: dayOfWeekIndex)
                )
            }
            .withVerticalDayMargin(8)
            .withHorizontalDayMargin(8)
            .withInterMonthSpacing(20)
    }

    private func compareToNow(_ day: Day) -> ComparisonResult? {
        guard let calendarDay = calendar.date(from: day.components) else { return nil }

        let result = calendar.compare(calendarDay, to: Date(), toGranularity: .day)

        return result
    }
}
