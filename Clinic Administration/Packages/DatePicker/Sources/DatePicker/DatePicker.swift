//
//  DatePicker.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import UIKit
import Design
import CalendarControl

public final class DatePicker: UIView {
    private enum DatePickerState: String {
        case today = "Сегодня"
        case tomorrow = "Завтра"
        case afterTomorrow = "Послезавтра"
        case calendar
        case none
    }

    private let today = Date()
    private let calendar = Calendar.current

    private let monthLabel = UILabel()
    private let dayLabel = UILabel()
    private let weekdayLabel = UILabel()

    private let selectionLine = UIView()

    private let buttonsStack = UIStackView()

    private let calendarImage = UIImage(systemName: "calendar")?
        .withTintColor(Design.Color.brown, renderingMode: .alwaysOriginal)
    private let selectedCalendarImage = UIImage(systemName: "calendar")?
        .withTintColor(Design.Color.lightGray, renderingMode: .alwaysOriginal)

    private var state: DatePickerState = .none

    private var selectedDate: Date {
        didSet {
            configureLabels()
            dateAction?(selectedDate)
        }
    }

    private var dateAction: ((Date) -> Void)?
    private var calendarAction: (() -> Void)?

    public init(selectedDate: Date, dateAction: @escaping (Date) -> Void, calendarAction: @escaping () -> Void) {
        self.selectedDate = selectedDate
        self.dateAction = dateAction
        self.calendarAction = calendarAction
        super.init(frame: .zero)

        layer.backgroundColor = Design.Color.chocolate.cgColor
        layer.cornerRadius = Design.CornerRadius.large

        setState(selectedDate: selectedDate)
        configureLabels()
        configureLabelsStack()
        configureButtonsStack(with: state)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        selectionLine.frame = CGRect(x: 0, y: buttonsStack.frame.maxY - 2, width: 30, height: 1)
        let offset = (selectionLine.frame.width - buttonsStack.arrangedSubviews[3].frame.width) / 2

        switch state {
        case .today: selectionLine.frame.origin.x = 20 + buttonsStack.arrangedSubviews[0].frame.origin.x
        case .tomorrow: selectionLine.frame.origin.x = 20 + buttonsStack.arrangedSubviews[1].frame.origin.x
        case .afterTomorrow: selectionLine.frame.origin.x = 20 + buttonsStack.arrangedSubviews[2].frame.origin.x
        default: selectionLine.frame.origin.x = 20 + buttonsStack.arrangedSubviews[3].frame.origin.x - offset
        }
    }

    private func configureLabels() {
        DateFormatter.shared.dateFormat = "LLLL d EEEE"

        let stringDate = DateFormatter.shared.string(from: selectedDate)
        let splitDate = stringDate.split(separator: " ")
        let month = "\(splitDate[0].capitalized)"
        let day = "\(splitDate[1])"
        let weekday = "\(splitDate[2])"

        monthLabel.text = month
        monthLabel.font = Design.Font.robotoFont(ofSize: 24, weight: .bold)
        monthLabel.textColor = Design.Color.white

        dayLabel.text = day
        dayLabel.font = Design.Font.robotoFont(ofSize: 24, weight: .regular)
        dayLabel.textColor = Design.Color.chocolate
        dayLabel.textAlignment = .center
        dayLabel.layer.backgroundColor = Design.Color.lightGray.cgColor
        dayLabel.layer.cornerRadius = Design.CornerRadius.small
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.widthAnchor.constraint(equalToConstant: 38).isActive = true

        weekdayLabel.text = weekday
        weekdayLabel.font = Design.Font.robotoFont(ofSize: 24, weight: .thin)
        weekdayLabel.textColor = Design.Color.white
    }

    private func configureLabelsStack() {
        let labelsStack = UIStackView(arrangedSubviews: [monthLabel, dayLabel, weekdayLabel])
        addSubview(labelsStack)
        labelsStack.axis = .horizontal
        labelsStack.alignment = .fill
        labelsStack.distribution = .equalSpacing
        labelsStack.spacing = 7
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelsStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            labelsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            labelsStack.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -40),
            labelsStack.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    private func configureButtonsStack(with state: DatePickerState) {
        let todayButton = button(title: DatePickerState.today.rawValue)
        todayButton.addTarget(self, action: #selector(today(_:)), for: .touchUpInside)

        let tomorrowButton = button(title: DatePickerState.tomorrow.rawValue)
        tomorrowButton.addTarget(self, action: #selector(tomorrow(_:)), for: .touchUpInside)

        let afterTomorrowButton = button(title: DatePickerState.afterTomorrow.rawValue)
        afterTomorrowButton.addTarget(self, action: #selector(afterTomorrow(_:)), for: .touchUpInside)

        let calendarButton = button(image: calendarImage)
        calendarButton.addTarget(self, action: #selector(calendar(_:)), for: .touchUpInside)

        for button in [todayButton, tomorrowButton, afterTomorrowButton, calendarButton] {
            buttonsStack.addArrangedSubview(button)
            if button.titleLabel?.text == state.rawValue {
                button.setTitleColor(Design.Color.lightGray, for: .normal)
            }
        }

        addSubview(buttonsStack)
        buttonsStack.axis = .horizontal
        buttonsStack.alignment = .center
        buttonsStack.distribution = .equalSpacing
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            buttonsStack.widthAnchor.constraint(equalTo: widthAnchor, constant: -40),
            buttonsStack.heightAnchor.constraint(equalToConstant: 28)
        ])

        selectionLine.backgroundColor = Design.Color.lightGray
        addSubview(selectionLine)
    }

    @objc private func today(_ sender: UIButton) {
        selectedDate = today
        buttonInteraction(sender)
    }

    @objc private func tomorrow(_ sender: UIButton) {
        selectedDate = today.addingTimeInterval(86_400)
        buttonInteraction(sender)
    }

    @objc private func afterTomorrow(_ sender: UIButton) {
        selectedDate = today.addingTimeInterval(172_800)
        buttonInteraction(sender)
    }

    @objc private func calendar(_ sender: UIButton) {
        UIView.animate(
            withDuration: 0.2,
            animations: {
                guard let buttons = self.buttonsStack.arrangedSubviews as? [UIButton] else { return }

                for button in buttons where button != sender {
                    button.setTitleColor(Design.Color.brown, for: .normal)
                }

                sender.setBackgroundImage(self.selectedCalendarImage, for: .normal)
                self.state = .calendar

                self.setNeedsLayout()
                self.layoutIfNeeded()
            },
            completion: { _ in
                self.calendarAction?()
            }
        )
    }

    private func buttonInteraction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            guard let buttons = self.buttonsStack.arrangedSubviews as? [UIButton] else { return }

            for button in buttons where button != sender {
                if button.backgroundImage(for: .normal) != nil {
                    button.setBackgroundImage(self.calendarImage, for: .normal)
                } else {
                    button.setTitleColor(Design.Color.brown, for: .normal)
                }
            }

            sender.setTitleColor(Design.Color.lightGray, for: .normal)

            guard let text = sender.titleLabel?.text else { return }

            self.state = DatePickerState(rawValue: text) ?? .calendar
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }

    private func button(title: String? = nil, image: UIImage? = nil) -> UIButton {
        let button = UIButton()

        if let buttonTitle = title {
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(Design.Color.brown, for: .normal)
            button.titleLabel?.font = Design.Font.robotoFont(ofSize: 15, weight: .regular)
        } else if let buttonImage = image {
            button.setBackgroundImage(buttonImage, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 25).isActive = true
            button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        }
        return button
    }

    private func setState(selectedDate: Date) {
        let tommorow = today.addingTimeInterval(86_400)
        let afterTommorow = today.addingTimeInterval(172_800)

        if calendar.isDate(selectedDate, inSameDayAs: today) {
            state = .today
        } else if calendar.isDate(selectedDate, inSameDayAs: tommorow) {
            state = .tomorrow
        } else if calendar.isDate(selectedDate, inSameDayAs: afterTommorow) {
            state = .afterTomorrow
        } else {
            state = .calendar
        }
    }

    private func stateAnimation() {
        setState(selectedDate: selectedDate)

        guard let buttons = buttonsStack.arrangedSubviews as? [UIButton] else { return }

        for button in buttons {
            if button.titleLabel?.text == state.rawValue {
                button.setTitleColor(Design.Color.lightGray, for: .normal)
            } else if button.backgroundImage(for: .normal) != nil, state != .calendar {
                button.setBackgroundImage(calendarImage, for: .normal)
            }
        }

        setNeedsLayout()
        layoutIfNeeded()
    }
}

extension DatePicker: CalendarViewControllerDelegate {
    public func selectedDate(_ date: Date) {
        selectedDate = date

        UIView.animate(withDuration: 0.2) {
            self.stateAnimation()
        }
    }

    public func cancelSelection() {
        UIView.animate(withDuration: 0.2) {
            self.stateAnimation()
        }
    }
}
