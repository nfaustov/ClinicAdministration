//
//  CustomDatePicker.swift
//  Clinic Administration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import UIKit

class DatePicker: UIView {
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    
    var currentDay = DateComponents(year: 2021, month: 2, day: 25, weekday: 4)
    
    private var monthLabel = UILabel()
    private var dayLabel = UILabel()
    private var weekdayLabel = UILabel()
    
    private let labelsStack = UIStackView()
    private let buttonsStack = UIStackView()

    private let image = UIImage(systemName: "calendar")?.withTintColor(Const.Color.brown, renderingMode: .alwaysOriginal)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.backgroundColor = Const.Color.darkBrown.cgColor
        layer.cornerRadius = Const.Shape.largeCornerRadius
        
        addSubview(labelsStack)
        labelsStack.axis = .horizontal
        labelsStack.alignment = .center
        labelsStack.distribution = .fillProportionally
        addSubview(buttonsStack)
        buttonsStack.axis = .horizontal
        buttonsStack.alignment = .center
        buttonsStack.distribution = .fillEqually
        
        buttonsStack.addArrangedSubview(button(title: "Сегодня"))
        buttonsStack.addArrangedSubview(button(title: "Завтра"))
        buttonsStack.addArrangedSubview(button(title: "Послезавтра"))
        buttonsStack.addArrangedSubview(button(image: image))
        
        configureLabels()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelsStack.frame = CGRect(x: 20, y: 12, width: bounds.width * 0.6, height: 28)
        buttonsStack.frame = CGRect(x: 20, y: 50, width: bounds.width - 20, height: 28)
    }
    
    private func configureLabels() {
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "LLLL dd EEEE"
        guard let date = calendar.date(from: currentDay) else { return }
        let stringDate = dateFormatter.string(from: date)
        let firstSpace = stringDate.firstIndex(of: " ") ?? stringDate.endIndex
        let month = stringDate[..<firstSpace]
//        monthLabel.text = String(str.split(
//        monthLabel.font = Const.Font.bold?.withSize(24)
//        monthLabel.sizeToFit()
//        labelsStack.addArrangedSubview(monthLabel)
//
//        dayLabel.text = String(str.split()[1])
//        dayLabel.font = Const.Font.regular?.withSize(24)
//        dayLabel.textAlignment = .center
//        dayLabel.sizeToFit()
//        dayLabel.backgroundColor = Const.Color.lightGray
//        dayLabel.layer.cornerRadius = Const.Shape.smallCornerRadius
//        labelsStack.addArrangedSubview(dayLabel)
//
//        weekdayLabel.text = String(str.split()[2])
//        weekdayLabel.font = Const.Font.thin?.withSize(24)
//        weekdayLabel.sizeToFit()
//        labelsStack.addArrangedSubview(weekdayLabel)
    }
    
    private func button(title: String? = nil, image: UIImage? = nil) -> UIButton {
        let button = UIButton()
        if let buttonTitle = title {
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(Const.Color.brown, for: .normal)
        } else if let buttonImage = image {
            button.setBackgroundImage(buttonImage, for: .normal)
        }
        return button
    }
}
