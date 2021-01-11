//
//  DoctorScheduleView.swift
//  Clinic Administration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import UIKit

final class DoctorScheduleView: UIView {
    
    let transformArea = UIView()
    let topResizingPoint = UIView()
    let bottomResizingPoint = UIView()
    
    private let nameLabel = UILabel()
    
    private var originalLocation = CGPoint()
    private var originalHeight = CGFloat()
    
    private var quarterHourHeight: CGFloat {
        GraphicTableView.Size.minuteHeight * 15
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
                view.isUserInteractionEnabled = mode == .editing ? true : false
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: Design.Shape.largeCornerRadius).cgPath
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = mode == .viewing ? 0.2 : 0
        layer.shadowColor = Design.Color.brown.cgColor
        layer.shadowRadius = 6
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
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        let generator = UINotificationFeedbackGenerator()
        gesture.minimumPressDuration = 0.7
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: gesture.minimumPressDuration,
                            delay: 0,
                            usingSpringWithDamping: 0.3,
                            initialSpringVelocity: 1,
                            options: .curveEaseOut) {
                if self.mode == .editing {
                    self.transform = .identity
                    self.layer.backgroundColor = Design.Color.lightGray.withAlphaComponent(0.75).cgColor
                    self.layer.borderColor = Design.Color.darkGray.cgColor
                    self.layer.shadowOpacity = 0.2
                    self.nameLabel.textColor = Design.Color.chocolate
                } else {
                    self.layer.backgroundColor = Design.Color.lightGray.withAlphaComponent(0.35).cgColor
                    self.layer.borderColor = Design.Color.darkGray.withAlphaComponent(0.6).cgColor
                    self.layer.shadowOpacity = 0
                    self.nameLabel.textColor = Design.Color.chocolate.withAlphaComponent(0.6)
                    self.transform = CGAffineTransform(scaleX: 1.1, y: 1)
                }
                generator.notificationOccurred(.success)
            }
        case .ended:
            mode = mode.change
        default: break
        }
    }
    
    @objc func handleBottomPanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let tY = translation.y - translation.y.truncatingRemainder(dividingBy: quarterHourHeight / 3)
        guard let cabinetView = superview else { return }
        switch gesture.state {
        case .began:
            originalLocation.y = frame.origin.y
            originalHeight = frame.height
        case .changed:
            let minTY = quarterHourHeight - originalHeight
            let maxTY = cabinetView.frame.height - originalLocation.y - originalHeight - 1
            frame.size.height = originalHeight + max(min(tY, maxTY), minTY)
        case .ended:
            setNeedsDisplay()
        default: break
        }
    }
    
    @objc func handleTopPanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let tY = translation.y - translation.y.truncatingRemainder(dividingBy: quarterHourHeight / 3)
        switch gesture.state {
        case .began:
            originalLocation.y = frame.origin.y
            originalHeight = frame.height
        case .changed:
            let minTY = -originalLocation.y
            let maxTY = originalHeight - quarterHourHeight
            frame.size.height = originalHeight - min(max(tY, minTY), maxTY)
            frame.origin.y = originalLocation.y + max(min(tY, maxTY), minTY)
        case .ended:
            setNeedsDisplay()
        default: break
        }
    }
}
