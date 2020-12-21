//
//  CalendarViewController.swift
//  Clinic Administration
//
//  Created by Nikolai Faustov on 13.12.2020.
//

import UIKit
import HorizonCalendar

protocol CalendarViewControllerDelegate: AnyObject {
    func selectedDate(_ date: DateComponents)
    
    func cancelSelection()
}

final class CalendarViewController: UIViewController {
    
    private var calendar = Calendar.current
    
    weak var delegate: CalendarViewControllerDelegate?
    
    private let confirmationView = ConfirmationView()
    private var topConstraint = NSLayoutConstraint()
    
    private var selectedDay: Day? {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateFormat = "LLLL d EEEE"
            
            if let components = selectedDay?.components,
               let pickedDate = calendar.date(from: components) {
                let stringDate = dateFormatter.string(from: pickedDate)
                let splitDate = stringDate.split(separator: " ")
                let month = splitDate[0].capitalized
                let day = splitDate[1]
                let weekday = splitDate[2]
                confirmationView.dateText = "\(month) \(day)\n\(weekday)"
                self.topConstraint.constant = -120
                
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Design.Color.white
        
        calendar.locale = Locale(identifier: "ru_RU")
        
        configureCalendar()
        configureConfirmation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let components = selectedDay?.components,
           let pickedDate = calendar.date(from: components) {
            delegate?.selectedDate(calendar.dateComponents([.year, .month, .day, .weekday], from: pickedDate))
        } else {
            delegate?.cancelSelection()
        }
    }
    
    private func configureCalendar() {
        let calendarView = CalendarView(initialContent: makeContent())
        calendarView.backgroundColor = Design.Color.white
        view.addSubview(calendarView)
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
        
        calendarView.daySelectionHandler = { [weak self] day in
            guard let self = self else { return }
            
            if self.compareToNow(day) != .orderedAscending {
                self.selectedDay = day
            }
            
            let newContent = self.makeContent()
            calendarView.setContent(newContent)
        }

    }
    
    private func makeContent() -> CalendarViewContent {
        let endDate = Date(timeInterval: 60 * 60 * 24 * 365, since: Date())
        
        let selectedDay = self.selectedDay

        return CalendarViewContent(calendar: calendar,
                                   visibleDateRange: Date()...endDate,
                                   monthsLayout: .vertical(options: VerticalMonthsLayoutOptions(pinDaysOfWeekToTop: true,
                                                                                                alwaysShowCompleteBoundaryMonths: true)))
            .withDayItemModelProvider { day in
                var invariantViewProperties = DayLabel.InvariantViewProperties(font: Design.Font.regular(19),
                                                                               textColor: Design.Color.brown,
                                                                               backgroundColor: .clear)
                
                if day == selectedDay {
                    invariantViewProperties.textColor = Design.Color.white
                    invariantViewProperties.backgroundColor = Design.Color.chocolate
                }
                
                if self.compareToNow(day) == .orderedAscending {
                    invariantViewProperties.textColor = Design.Color.gray
                }

                return CalendarItemModel<DayLabel>(invariantViewProperties: invariantViewProperties,
                                                   viewModel: .init(day: day))
            }
            .withMonthHeaderItemModelProvider { month in
                CalendarItemModel<MonthHeader>(invariantViewProperties: .init(font: Design.Font.medium(22),
                                                                              textColor: Design.Color.chocolate,
                                                                              backgoundColor: .clear),
                                               viewModel: .init(month: month))
            }
            .withDayOfWeekItemModelProvider { _, dayOfWeekIndex in
                CalendarItemModel<DayOfWeekRow>(invariantViewProperties: .init(font: Design.Font.medium(17),
                                                                                 textColor: Design.Color.darkGray,
                                                                                 backgroundColor: .clear),
                                                  viewModel: .init(dayOfWeekIndex: dayOfWeekIndex))
            }
            .withDaysOfTheWeekRowSeparator(options: .init(height: 1, color: Design.Color.darkGray))
            .withVerticalDayMargin(8)
            .withHorizontalDayMargin(8)
            .withInterMonthSpacing(20)
    }
    
    private func configureConfirmation() {
        view.addSubview(confirmationView)
        
        confirmationView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = confirmationView.topAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            topConstraint,
            confirmationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            confirmationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            confirmationView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        confirmationView.confirmAction = { [weak self] in
            guard let self = self else { return }
            
            self.dismiss(animated: true)
        }
        
        confirmationView.cancelAction = { [weak self] in
            guard let self = self else { return }
            
            self.selectedDay = nil
            self.dismiss(animated: true)
        }
    }
    
    private func compareToNow(_ day: Day) -> ComparisonResult {
        let calendarDay = self.calendar.date(from: day.components)
        let result = calendar.compare(calendarDay!, to: Date(), toGranularity: .day)
        
        return result
    }
}
