//
//  DoctorScheduleView.swift
//  Clinic Administration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import UIKit

final class DoctorScheduleView: UIView {
    
    let transformArea = UIView()
    private let topResizingPoint = UIView()
    private let bottomResizingPoint = UIView()
    
    private let nameLabel = UILabel()
    
    private let minuteHeight: CGFloat
    
    private var originalLocation = CGPoint.zero
    private var originalHeight = CGFloat.zero
    private var minutesInterval = CGFloat.zero
    
    /// Данное свойство является true, если расписание пересекающееся.
    private var isIntersected: Bool! {
        return intersectionDetection?(schedule)
    }
    
    private enum Mode {
        case editing, viewing
        
        var change: Mode {
            switch self {
            case .editing: return .viewing
            case .viewing: return .editing
            }
        }
    }
    
    private var mode: Mode = .viewing {
        didSet {
            for view in [topResizingPoint, transformArea, bottomResizingPoint] {
                view.isUserInteractionEnabled = mode == .editing
            }
        }
    }
    
    private(set) var schedule: DoctorSchedule
    
    /// Замыкание, которое выясняет является ли расписание пересекающимся.
    private var intersectionDetection: ((DoctorSchedule) -> Bool)?
    
    /// Замыкание, которое выводит вью доктора на передний план.
    ///
    /// Используется, когда экземпляр `DoctorScheduleView` переводится в режим редактирования или когда является пересекающимся.
    private var moveToFrontAction: ((DoctorScheduleView) -> Void)?
    
    override func draw(_ rect: CGRect) {
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: Design.Shape.largeCornerRadius).cgPath
        layer.shadowColor = Design.Color.brown.cgColor
    }
    
    /// Инициализирует `DoctorScheduleView`.
    /// - Parameters:
    ///   - schedule: Расписание доктора.
    ///   - minuteHeight: Высота минуты на экране.
    ///   - intersectionDetection: Метод, который выясняет является ли расписание пересекающимся.
    ///   - moveToFrontAction: Метод, которое выводит вью доктора на передний план.
    init(_ schedule: DoctorSchedule, minuteHeight: CGFloat, intersectionDetection: @escaping (DoctorSchedule) -> Bool, moveToFrontAction: @escaping (DoctorScheduleView) -> Void) {
        self.schedule = schedule
        self.minuteHeight = minuteHeight
        self.intersectionDetection = intersectionDetection
        self.moveToFrontAction = moveToFrontAction
        super.init(frame: .zero)
        
        layer.cornerRadius = Design.Shape.largeCornerRadius
        checkState()

        nameLabel.numberOfLines = 0
        nameLabel.text = "\(schedule.secondName)\n\(schedule.firstName)\n\(schedule.patronymicName)"
        nameLabel.textAlignment = .center
        nameLabel.font = Design.Font.medium(13)
        nameLabel.sizeToFit()
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        configureGestureAreas()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureGestureAreas() {
        let topPan = UIPanGestureRecognizer(target: self, action: #selector(handleTopPanGesture(_:)))
        let bottomPan = UIPanGestureRecognizer(target: self, action: #selector(handleBottomPanGesture(_:)))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        
        topResizingPoint.addGestureRecognizer(topPan)
        bottomResizingPoint.addGestureRecognizer(bottomPan)
        addGestureRecognizer(longPress)
        
        addSubview(topResizingPoint)
        addSubview(transformArea)
        addSubview(bottomResizingPoint)
        for view in [topResizingPoint, transformArea, bottomResizingPoint] {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            topResizingPoint.topAnchor.constraint(equalTo: topAnchor),
            topResizingPoint.leadingAnchor.constraint(equalTo: leadingAnchor),
            topResizingPoint.trailingAnchor.constraint(equalTo: trailingAnchor),
            topResizingPoint.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
            
            transformArea.topAnchor.constraint(equalTo: topResizingPoint.bottomAnchor),
            transformArea.leadingAnchor.constraint(equalTo: leadingAnchor),
            transformArea.trailingAnchor.constraint(equalTo: trailingAnchor),
            transformArea.bottomAnchor.constraint(equalTo: bottomResizingPoint.topAnchor),
            
            bottomResizingPoint.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomResizingPoint.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomResizingPoint.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomResizingPoint.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1)
        ])
        
        topResizingPoint.isUserInteractionEnabled = false
        transformArea.isUserInteractionEnabled = false
        bottomResizingPoint.isUserInteractionEnabled = false
    }
    
    /// Данный метод используется для проверки текущего статуса и установки нужного состояния объекта `DoctorScheduleView`
    func checkState() {
        switch mode {
        case .editing:
            layer.backgroundColor = Design.Color.lightGray.withAlphaComponent(0.35).cgColor
            layer.borderColor = Design.Color.darkGray.withAlphaComponent(0.6).cgColor
            layer.borderWidth = 1
            layer.shadowOpacity = 0
            nameLabel.textColor = Design.Color.chocolate.withAlphaComponent(0.6)
            transform = .init(scaleX: 1.1, y: 1)
            // Если в режиме редактирования то через замыкание переместим вью на передний план.
            moveToFrontAction?(self)
        case .viewing:
            nameLabel.textColor = Design.Color.chocolate
            transform = .identity
            if isIntersected {
                layer.backgroundColor = Design.Color.lightGray.withAlphaComponent(0.2).cgColor
                layer.borderColor = Design.Color.red.cgColor
                layer.borderWidth = 2
                layer.shadowOffset = CGSize(width: 0, height: 6)
                layer.shadowRadius = 12
                layer.shadowOpacity = 0.15
                // Если расписаие пересекает другие, то через замыкание переместим вью на передний план.
                moveToFrontAction?(self)
            } else {
                layer.backgroundColor = Design.Color.lightGray.withAlphaComponent(0.75).cgColor
                layer.borderColor = Design.Color.darkGray.cgColor
                layer.borderWidth = 1
                layer.shadowOffset = CGSize(width: 0, height: 3)
                layer.shadowRadius = 6
                layer.shadowOpacity = 0.2
            }
        }
    }
    
    /// Опции редактирования расписания доктора.
    enum ScheduleEditOption {
        case startingTime
        case endingTime
        // Вероятно тут еще и кабинет появится со временем.
    }
    
    
    /// Данный метод используется для редактирования расписания доктора.
    /// - Parameters:
    ///   - options: Опции редактирования расписания доктора.
    ///   - timeInterval: Временной интервал в секундах для изменения расписания доктоа.
    func editSchedule(options: Set<ScheduleEditOption>, by timeInterval: TimeInterval) {
        if options.contains(.startingTime) {
            schedule.startingTime.addTimeInterval(timeInterval)
        }
        if options.contains(.endingTime) {
            schedule.endingTime.addTimeInterval(timeInterval)
        }
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        let generator = UINotificationFeedbackGenerator()
        gesture.minimumPressDuration = 0.7
        switch gesture.state {
        case .began:
            mode = mode.change
            UIView.animate(withDuration: 0.7,
                            delay: 0,
                            usingSpringWithDamping: 0.3,
                            initialSpringVelocity: 1,
                            options: .curveEaseOut) {
                self.checkState()
                generator.notificationOccurred(.success)
            }
        default: break
        }
    }
    
    @objc func handleBottomPanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let tY = translation.y - translation.y.truncatingRemainder(dividingBy: 5 * minuteHeight)
        guard let cabinetView = superview else { return }
        switch gesture.state {
        case .began:
            originalLocation.y = frame.origin.y
            originalHeight = frame.height
        case .changed:
            let minTY = 15 * minuteHeight - originalHeight
            let maxTY = cabinetView.frame.height - originalLocation.y - originalHeight - 1
            frame.size.height = originalHeight + max(min(tY, maxTY), minTY)
            // Переводим translation в минуты.
            minutesInterval = max(min(tY, maxTY), minTY) / minuteHeight
        case .ended:
            // Меняем расписание доктора.
            editSchedule(options: [.endingTime], by: TimeInterval(minutesInterval * 60))
            setNeedsDisplay()
        default: break
        }
    }
    
    @objc func handleTopPanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let tY = translation.y - translation.y.truncatingRemainder(dividingBy: minuteHeight * 5)
        switch gesture.state {
        case .began:
            originalLocation.y = frame.origin.y
            originalHeight = frame.height
        case .changed:
            let minTY = -originalLocation.y
            let maxTY = originalHeight - 15 * minuteHeight
            frame.size.height = originalHeight - min(max(tY, minTY), maxTY)
            frame.origin.y = originalLocation.y + max(min(tY, maxTY), minTY)
            // Переводим translation в минуты.
            minutesInterval = max(min(tY, maxTY), minTY) / minuteHeight
        case .ended:
            // Меняем расписание доктора.
            editSchedule(options: [.startingTime], by: TimeInterval(minutesInterval * 60))
            setNeedsDisplay()
        default: break
        }
    }
}