//
//  DoctorScheduleView.swift
//  Clinic Administration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import UIKit

class DoctorScheduleView: UIView {
    
    let transformArea = UIView() // зона для перемещения расписания
    private let topResizingPoint = UIView() // две зоны для изменения начала и конца расписания
    private let bottomResizingPoint = UIView()
    
    private let closeButton = UIButton() // кнопка для деактивации вью
    
    private let nameLabel = UILabel() // имя врача
    
    private var originalLocation = CGPoint() // переменные для pan gesture
    private var originalHeight = CGFloat()
    
    override func draw(_ rect: CGRect) {
        // планирую позже добавить тень
    }
    
    init(_ schedule: DoctorSchedule) {
        super.init(frame: .zero)
        
        layer.backgroundColor = Design.Color.lightGray.withAlphaComponent(0.75).cgColor
        layer.cornerRadius = Design.Shape.largeCornerRadius
        layer.borderColor = Design.Color.darkGray.cgColor
        layer.borderWidth = 1
        
        nameLabel.numberOfLines = 0
        nameLabel.text = "\(schedule.secondName)\n\(schedule.firstName)\n\(schedule.patronymicName)"
        nameLabel.textAlignment = .center
        nameLabel.textColor = Design.Color.chocolate
        nameLabel.font = Design.Font.medium(13)
        nameLabel.sizeToFit()
        addSubview(nameLabel)
        
        configureGestureAreas()
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        topResizingPoint.frame = CGRect(x: 0, y: 0, width: bounds.width, height: Size.resizingPointHeight)
        transformArea.frame = CGRect(x: 0, y: Size.resizingPointHeight, width: bounds.width, height: bounds.height - Size.resizingPointHeight * 2)
        bottomResizingPoint.frame = CGRect(x: 0, y: bounds.height - Size.resizingPointHeight, width: bounds.width, height: Size.resizingPointHeight)
        closeButton.frame = CGRect(x: 0, y: Design.Shape.largeCornerRadius, width: 35, height: 35)
    }
    
    private func configureGestureAreas() {
        let topPan = UIPanGestureRecognizer(target: self, action: #selector(handleTopPanGesture(_:)))
        let bottomPan = UIPanGestureRecognizer(target: self, action: #selector(handleBottomPanGesture(_:)))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        
        topResizingPoint.addGestureRecognizer(topPan) // каждой зоне добавляем определенный жест
        bottomResizingPoint.addGestureRecognizer(bottomPan)
        addGestureRecognizer(longPress)
        
        addSubview(topResizingPoint)
        addSubview(transformArea)
        addSubview(bottomResizingPoint)
        
        topResizingPoint.isUserInteractionEnabled = false
        transformArea.isUserInteractionEnabled = false
        bottomResizingPoint.isUserInteractionEnabled = false
    }
    
    private func configureButton() {
        let image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(Design.Color.chocolate, renderingMode: .alwaysOriginal)
        closeButton.setBackgroundImage(image, for: .normal)
        closeButton.addTarget(self, action: #selector(disableUserInteractions(_:)), for: .touchUpInside)
        closeButton.isHidden = true
        closeButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        addSubview(closeButton)
    }
    
    @objc func disableUserInteractions(_ sender: UIButton) {
        // деактивацию пока реализовал через кнопку, но не уверен, что это хорошо выглядит, особенно если сжать расписание минут до 15
        let generator = UIImpactFeedbackGenerator(style: .medium)
        
        topResizingPoint.isUserInteractionEnabled = false
        transformArea.isUserInteractionEnabled = false
        bottomResizingPoint.isUserInteractionEnabled = false

        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) {
            self.transform = .identity
            self.layer.backgroundColor = Design.Color.lightGray.withAlphaComponent(0.75).cgColor
            self.layer.borderColor = Design.Color.darkGray.cgColor
            self.nameLabel.textColor = Design.Color.chocolate
            sender.isHidden = true
            generator.impactOccurred()
        } completion: { _ in
            sender.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) { // длительное нажатие активирует расписание для редактирования
        let generator = UINotificationFeedbackGenerator()
        gesture.minimumPressDuration = 0.7
        switch gesture.state {
        case .began:
            closeButton.isHidden = false
            UIView.animate(withDuration: gesture.minimumPressDuration,
                           delay: 0,
                           usingSpringWithDamping: 0.3,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut) {
                self.layer.backgroundColor = Design.Color.lightGray.withAlphaComponent(0.35).cgColor
                self.layer.borderColor = Design.Color.darkGray.withAlphaComponent(0.6).cgColor
                self.nameLabel.textColor = Design.Color.chocolate.withAlphaComponent(0.6)
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1)
                self.closeButton.transform = .identity
                generator.notificationOccurred(.success)
            }
        case .ended:
            topResizingPoint.isUserInteractionEnabled = true
            transformArea.isUserInteractionEnabled = true
            bottomResizingPoint.isUserInteractionEnabled = true
        default: break
        }
        
    }
    
    @objc func handleBottomPanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let tY = translation.y - translation.y.truncatingRemainder(dividingBy: Size.quarterHourHeight / 3) // расписание меняется с шагом 5 минут (10 поинтов)
        switch gesture.state {
        case .began:
            originalHeight = frame.height
        case .changed:
            frame.size.height = originalHeight + tY
        default: break
        }
    }
    
    @objc func handleTopPanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let tY = translation.y - translation.y.truncatingRemainder(dividingBy: Size.quarterHourHeight / 3)
        switch gesture.state {
        case .began:
            originalLocation.y = frame.origin.y
            originalHeight = frame.height
        case .changed:
            frame.size.height = originalHeight - tY
            frame.origin.y = originalLocation.y + tY
        default: break
        }
    }
}

extension DoctorScheduleView {
    private enum Size {
        static let resizingPointHeight: CGFloat = 15
        static let quarterHourHeight: CGFloat = 30
    }
}
