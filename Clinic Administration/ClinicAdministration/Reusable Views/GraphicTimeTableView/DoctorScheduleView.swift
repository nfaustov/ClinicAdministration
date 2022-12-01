//
//  DoctorScheduleView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import UIKit

final class DoctorScheduleView: UIView {
    private enum Mode {
        case editing
        case viewing

        var change: Mode {
            switch self {
            case .editing: return .viewing
            case .viewing: return .editing
            }
        }
    }

    private enum PanGestureKind {
        case bottom
        case top

        var editingOptions: Set<ScheduleEditOption> {
            switch self {
            case .top: return [.startingTime]
            case .bottom: return [.endingTime]
            }
        }
    }

    enum ScheduleEditOption {
        case startingTime
        case endingTime
    }

    let transformArea = UIView()
    private let topResizingPoint = UIView()
    private let bottomResizingPoint = UIView()

    private let nameLabel = UILabel()

    private let minuteHeight: CGFloat

    private var originalLocation = CGPoint.zero
    private var originalHeight = CGFloat.zero
    private var minutesInterval = CGFloat.zero

    private var serviceDurationHeight: CGFloat {
        schedule.serviceDuration / 60 * minuteHeight
    }

    private var mode: Mode = .viewing {
        didSet {
            for view in [topResizingPoint, transformArea, bottomResizingPoint] {
                view.isUserInteractionEnabled = mode == .editing
            }
        }
    }

    private var hasChanges = false

    private(set) var schedule: DoctorSchedule

    private var editingAction: ((DoctorSchedule) -> Void)?

    init(
        _ schedule: DoctorSchedule,
        minuteHeight: CGFloat,
        editingAction: @escaping (DoctorSchedule) -> Void
    ) {
        self.schedule = schedule
        self.minuteHeight = minuteHeight
        self.editingAction = editingAction
        super.init(frame: .zero)

        layer.shadowColor = Design.Color.brown.cgColor
        layer.cornerRadius = Design.CornerRadius.large

        checkState()
        configureNameLabel()
        configureGestureAreas()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: Design.CornerRadius.large).cgPath
    }

    private func configureNameLabel() {
        nameLabel.text = """
        \(schedule.doctor.secondName)
        \(schedule.doctor.firstName)
        \(schedule.doctor.patronymicName)
        """
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.font = Design.Font.robotoFont(ofSize: 11, weight: .medium)
        nameLabel.sizeToFit()
        addSubview(nameLabel)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func configureGestureAreas() {
        let topPan = UIPanGestureRecognizer(target: self, action: #selector(handleTopPanGesture(_:)))
        let bottomPan = UIPanGestureRecognizer(target: self, action: #selector(handleBottomPanGesture(_:)))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))

        topResizingPoint.addGestureRecognizer(topPan)
        bottomResizingPoint.addGestureRecognizer(bottomPan)
        addGestureRecognizer(longPress)

        for view in [topResizingPoint, transformArea, bottomResizingPoint] {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.isUserInteractionEnabled = false
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
    }

    private func checkChanges() {
        if hasChanges {
            editingAction?(schedule)
            hasChanges = false
        }
    }

    func checkState() {
        switch mode {
        case .editing:
            layer.backgroundColor = Design.Color.lightGray.withAlphaComponent(0.35).cgColor
            layer.borderColor = Design.Color.darkGray.withAlphaComponent(0.6).cgColor
            layer.borderWidth = 1
            layer.shadowOpacity = 0
            nameLabel.textColor = Design.Color.chocolate.withAlphaComponent(0.6)
            transform = .init(scaleX: 1.1, y: 1)
        case .viewing:
            nameLabel.textColor = Design.Color.chocolate
            transform = .identity
            layer.backgroundColor = Design.Color.lightGray.withAlphaComponent(0.75).cgColor
            layer.borderColor = Design.Color.darkGray.cgColor
            layer.borderWidth = 1
            layer.shadowOffset = CGSize(width: 0, height: 3)
            layer.shadowRadius = 6
            layer.shadowOpacity = 0.2
        }
    }

    func editSchedule(options: Set<ScheduleEditOption>, by timeInterval: TimeInterval) {
        guard timeInterval != 0 else { return }

        if options.contains(.startingTime) {
            schedule.startingTime.addTimeInterval(timeInterval)
        }
        if options.contains(.endingTime) {
            schedule.endingTime.addTimeInterval(timeInterval)
        }

        hasChanges = true
    }

    private func gestureChanged(_ gesture: UIPanGestureRecognizer, of kind: PanGestureKind) {
        let translation = gesture.translation(in: self)
        let translationY = translation.y - translation.y.truncatingRemainder(dividingBy: serviceDurationHeight)

        guard let cabinetView = superview else { return }

        let minTY: CGFloat
        let maxTY: CGFloat

        switch kind {
        case .bottom:
            maxTY = cabinetView.frame.height - originalLocation.y - originalHeight - 1

            if let appointment = schedule.patientAppointments.last(where: { $0.patient != nil }),
               let appointmentEnding = appointment.scheduledTime?.addingTimeInterval(appointment.duration) {
                let minutesInterval = schedule.endingTime.timeIntervalSince(appointmentEnding) / 60
                minTY = -minutesInterval * minuteHeight
            } else {
                minTY = serviceDurationHeight - originalHeight
            }

            frame.size.height = originalHeight + max(min(translationY, maxTY), minTY)
        case .top:
            minTY = -originalLocation.y

            if let appointment = schedule.patientAppointments.first(where: { $0.patient != nil }),
               let appointmentStarting = appointment.scheduledTime {
                let minutesInterval = appointmentStarting.timeIntervalSince(schedule.startingTime) / 60
                maxTY = minutesInterval * minuteHeight
            } else {
                maxTY = originalHeight - serviceDurationHeight
            }

            frame.size.height = originalHeight - min(max(translationY, minTY), maxTY)
            frame.origin.y = originalLocation.y + max(min(translationY, maxTY), minTY)
        }

        minutesInterval = max(min(translationY, maxTY), minTY) / minuteHeight
    }

    private func panGesture(_ gesture: UIPanGestureRecognizer, ofKind kind: PanGestureKind) {
        switch gesture.state {
        case .began:
            originalLocation.y = frame.origin.y
            originalHeight = frame.height
        case .changed:
            gestureChanged(gesture, of: kind)
        case .ended:
            editSchedule(options: kind.editingOptions, by: TimeInterval(minutesInterval * 60))
            setNeedsDisplay()
        default: break
        }
    }

    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        let generator = UINotificationFeedbackGenerator()

        gesture.minimumPressDuration = 0.7

        switch gesture.state {
        case .began:
            mode = mode.change
            UIView.animate(
                withDuration: 0.7,
                delay: 0,
                usingSpringWithDamping: 0.3,
                initialSpringVelocity: 1,
                options: .curveEaseOut
            ) {
                self.checkState()
                if self.mode == .viewing { self.checkChanges() }
                generator.notificationOccurred(.success)
            }
        default: break
        }
    }

    @objc private func handleBottomPanGesture(_ gesture: UIPanGestureRecognizer) {
        panGesture(gesture, ofKind: .bottom)
    }

    @objc private func handleTopPanGesture(_ gesture: UIPanGestureRecognizer) {
        panGesture(gesture, ofKind: .top)
    }
}
