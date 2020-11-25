//
//  DatePicker.swift
//  Clinic Administration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import UIKit

protocol DatePickerDelegate: AnyObject {
    func selectedDate(_ date: DateComponents)
}

class DatePicker: UIView {
    
    private let date = Date()
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    
    private var monthLabel = UILabel() // лейблы для отображения даты
    private var dayLabel = UILabel()
    private var weekdayLabel = UILabel()
    
    private let selectionLine = UIView() // подчеркивание, которое анимировано перемещается
    private var selectionLineLeading = NSLayoutConstraint() // leadingAnchor этой линии
    
    private var buttons = [UIButton]()

    private let calendarImage = UIImage(systemName: "calendar")?.withTintColor(Design.Color.brown, renderingMode: .alwaysOriginal) // картинки для кнопки с календарем
    private let selectedCalendarImage = UIImage(systemName: "calendar")?.withTintColor(Design.Color.lightGray, renderingMode: .alwaysOriginal)
    
    weak var delegate: DatePickerDelegate?
    
    var currentDate = DateComponents() {
        didSet {
            configureLabels()
        }
    }
    
    init(currentDate components: DateComponents) {
        super.init(frame: .zero)
        
        layer.backgroundColor = Design.Color.chocolate.cgColor
        layer.cornerRadius = Design.Shape.largeCornerRadius
        
        currentDate = components
        
        configureLabels()
        configureLabelsStack()
        configureButtonsStack()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureLabels() {
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "LLLL d EEEE"
        
        guard let date = calendar.date(from: currentDate) else { return }
        let stringDate = dateFormatter.string(from: date)
        let splitDate = stringDate.split(separator: " ")
        let month = "\(splitDate[0].capitalized)"
        let day = "\(splitDate[1])"
        let weekday = "\(splitDate[2])"

        monthLabel.text = month
        monthLabel.font = Design.Font.bold(24)
        monthLabel.textColor = Design.Color.white

        dayLabel.text = day
        dayLabel.font = Design.Font.regular(24)
        dayLabel.textColor = Design.Color.chocolate
        dayLabel.textAlignment = .center
        dayLabel.layer.backgroundColor = Design.Color.lightGray.cgColor
        dayLabel.layer.cornerRadius = Design.Shape.smallCornerRadius
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.widthAnchor.constraint(equalToConstant: 38).isActive = true

        weekdayLabel.text = weekday
        weekdayLabel.font = Design.Font.thin(24)
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
    
    private func configureButtonsStack() {
        let todayButton = button(title: "Сегодня")
        todayButton.setTitleColor(Design.Color.lightGray, for: .normal)
        todayButton.addTarget(self, action: #selector(today(_:)), for: .touchUpInside)
        
        let tomorrowButton = button(title: "Завтра")
        tomorrowButton.addTarget(self, action: #selector(tomorrow(_:)), for: .touchUpInside)
        
        let afterTomorrowButton = button(title: "Послезавтра")
        afterTomorrowButton.addTarget(self, action: #selector(afterTomorrow(_:)), for: .touchUpInside)
        
        let calendarButton = button(image: calendarImage)
        calendarButton.addTarget(self, action: #selector(calendar(_:)), for: .touchUpInside)
        
        buttons = [todayButton, tomorrowButton, afterTomorrowButton, calendarButton]
        let buttonsStack = UIStackView(arrangedSubviews: buttons)
        addSubview(buttonsStack)
        buttonsStack.axis = .horizontal
        buttonsStack.alignment = .center
        buttonsStack.distribution = .fill
        buttonsStack.spacing = 30
        buttonsStack.setCustomSpacing(45, after: afterTomorrowButton)
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        selectionLine.backgroundColor = Design.Color.lightGray
        addSubview(selectionLine)
        selectionLine.translatesAutoresizingMaskIntoConstraints = false
        selectionLineLeading = selectionLine.leadingAnchor.constraint(equalTo: todayButton.leadingAnchor)
        
        NSLayoutConstraint.activate([
            buttonsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            buttonsStack.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -40),
            buttonsStack.heightAnchor.constraint(equalToConstant: 28),
            selectionLine.topAnchor.constraint(equalTo: buttonsStack.bottomAnchor, constant: -1),
            selectionLineLeading,
            selectionLine.widthAnchor.constraint(equalToConstant: 30),
            selectionLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    @objc func today(_ sender: UIButton) {
        currentDate = calendar.dateComponents([.year, .month, .day, .weekday], from: date) // текущая дата
        buttonInteraction(sender)
        delegate?.selectedDate(currentDate)
    }
    
    @objc func tomorrow(_ sender: UIButton) {
        let tomorrow = Date(timeInterval: 86400, since: date) // добавляем день к текущей дате
        currentDate = calendar.dateComponents([.year, .month, .day, .weekday], from: tomorrow)
        buttonInteraction(sender)
        delegate?.selectedDate(currentDate)
    }
    
    @objc func afterTomorrow(_ sender: UIButton) {
        let afterTomorrow = Date(timeInterval: 172800, since: date) // добавляем два дня к текущей дате
        currentDate = calendar.dateComponents([.year, .month, .day, .weekday], from: afterTomorrow)
        buttonInteraction(sender)
        delegate?.selectedDate(currentDate)
    }
    
    @objc func calendar(_ sender: UIButton) { // календарь для выбора дат пока не добавлял в приложение
        let offset = (selectionLine.frame.width - sender.frame.width) / 2
        selectionLineLeading.constant = sender.frame.origin.x - offset
        UIView.animate(withDuration: 0.2) {
            for button in self.buttons {
                if button != sender {
                    button.setTitleColor(Design.Color.brown, for: .normal)
                }
            }
            sender.setBackgroundImage(self.selectedCalendarImage, for: .normal)
            self.layoutIfNeeded()
        }
    }
    
    private func buttonInteraction(_ sender: UIButton) {
        selectionLineLeading.constant = sender.frame.origin.x // подчеркивание анимировано перемещается к нажатой кнопке
        UIView.animate(withDuration: 0.2) {
            for button in self.buttons {
                if button != sender {
                    if button.backgroundImage(for: .normal) != nil { // если у кнопки есть изображение, то меняем изображение на неактивное
                        button.setBackgroundImage(self.calendarImage, for: .normal)
                    } else {
                        button.setTitleColor(Design.Color.brown, for: .normal) // иначе меняем цвет title на неактивный
                    }
                }
            }
            sender.setTitleColor(Design.Color.lightGray, for: .normal) // у sender меняем цвет на активный
            self.layoutIfNeeded()
        }
    }
    
    private func button(title: String? = nil, image: UIImage? = nil) -> UIButton { // общая функция для конфигурирования кнопок
        let button = UIButton()
        if let buttonTitle = title {
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(Design.Color.brown, for: .normal)
            button.titleLabel?.font = Design.Font.regular(15)
        } else if let buttonImage = image {
            button.setBackgroundImage(buttonImage, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 25).isActive = true
            button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        }
        return button
    }
}
