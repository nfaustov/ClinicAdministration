//
//  GraphicTimeTableView.swift
//  Clinic Administration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import UIKit

final class GraphicTableView: UIView {
    
    var date: DateComponents { 
        didSet {
            setTimeTable(date)
            reloadData()
            setNeedsDisplay()
        }
    }
    
    private let calendar = Calendar.current
    
    private(set) var opening = DateComponents()
    private(set) var close = DateComponents()
    
    private var schedules: [DoctorSchedule] {
        let dataSource = TimeTableDataSource()
        return dataSource.filterSchedules(for: date)
    }

    var cabinets = 5
    
    private let headerView = UIView()
    private let footerView = UIView()
    
    private var cabinetViews = [UIView]()
    private var cabinetLabels = [UILabel]()
    
    private(set) var doctorViews = [DoctorScheduleView]()
    
    private var originalLocation = CGPoint()
    
    private var transformAction: ((DoctorScheduleView, CGFloat) -> Void)?
    
    private func setTimeTable(_ date: DateComponents) {
        opening = date
        close = date
        
        switch date.weekday {
        case 1:
            opening.hour = 9
            close.hour = 15
        case 7:
            opening.hour = 9
            close.hour = 18
        default:
            opening.hour = 8
            close.hour = 19
        }
    }

    override func draw(_ rect: CGRect) {
        let linePath = UIBezierPath()
        let dashLinePath = UIBezierPath()
        
        for quarterHour in 1...(close.hour! - opening.hour! + 1) * 4 {
            if (quarterHour - 1) % 4 == 0 {
                linePath.move(to: CGPoint(x: Size.lineOffset, y: Int(Size.headerHeight) + Int(quarterHourHeight) * quarterHour))
                linePath.addLine(to: CGPoint(x: Int(bounds.width) - Size.lineOffset, y: Int(Size.headerHeight) + Int(quarterHourHeight) * quarterHour))
            } else {
                dashLinePath.move(to: CGPoint(x: Size.lineOffset, y: Int(Size.headerHeight) + Int(quarterHourHeight) * quarterHour))
                dashLinePath.addLine(to: CGPoint(x: Int(bounds.width) - Size.lineOffset, y: Int(Size.headerHeight) + Int(quarterHourHeight) * quarterHour))
            }
        }
        
        let dashes: [CGFloat] = [5, 5]
        dashLinePath.setLineDash(dashes, count: dashes.count, phase: 0)
        
        dashLinePath.close()
        Design.Color.gray.set()
        dashLinePath.stroke()

        linePath.close()
        Design.Color.gray.set()
        linePath.stroke()
    }
    
    init(date: DateComponents, transformAction: @escaping (DoctorScheduleView, CGFloat) -> Void) {
        self.date = date
        self.transformAction = transformAction
        super.init(frame: .zero)
        
        setTimeTable(date)
        
        backgroundColor = Design.Color.white
        layer.cornerRadius = Design.Shape.largeCornerRadius
        layer.masksToBounds = true
        
        setupHeaderFooter()
        setupCabinetLabels()
        addCabinets(cabinets)
        schedules.forEach { (schedule) in
            addDoctorSchedule(schedule)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        for doctorView in doctorViews {
            doctorView.removeFromSuperview()
            doctorViews.remove(at: 0)
        }
        schedules.forEach { (schedule) in
            addDoctorSchedule(schedule)
        }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cabinetViewWidth = (bounds.width - Size.timelineWidth) / CGFloat(cabinets)
        
        for cabinet in 0..<cabinets {
            cabinetLabels[cabinet].center = CGPoint(x: Size.timelineWidth + cabinetViewWidth / 2 * CGFloat(cabinet * 2 + 1), y: headerView.frame.height / 2)
            cabinetViews[cabinet].frame = CGRect(x: Size.timelineWidth + cabinetViewWidth * CGFloat(cabinet),
                                                 y: Size.headerHeight + quarterHourHeight,
                                                 width: cabinetViewWidth,
                                                 height: bounds.height - Size.headerHeight * 2 - quarterHourHeight)
        }
        
        for index in schedules.indices {
            let timeIntervalFromOpening = calendar.dateComponents([.hour, .minute],
                                                                  from: opening,
                                                                  to: schedules[index].startingTime)
            let timeIntervalFromStarting = calendar.dateComponents([.hour, .minute],
                                                                   from: schedules[index].startingTime,
                                                                   to: schedules[index].endingTime)

            let minutesFromOpening = CGFloat(timeIntervalFromOpening.hour! * 60 + timeIntervalFromOpening.minute!)
            let scheduleMinutes = CGFloat(timeIntervalFromStarting.hour! * 60 + timeIntervalFromStarting.minute!)

            doctorViews[index].frame = CGRect(x: Size.doctorViewOffset,
                                              y: minutesFromOpening * Size.minuteHeight,
                                              width: cabinetViewWidth - Size.doctorViewOffset * 2,
                                              height: scheduleMinutes * Size.minuteHeight)
        }
    }
    
    private func setupHeaderFooter() {
        addSubview(headerView)
        headerView.backgroundColor = Design.Color.chocolate
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(footerView)
        footerView.backgroundColor = Design.Color.chocolate
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Size.headerHeight),
            
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: Size.headerHeight)
        ])
    }
    
    private func setupCabinetLabels() {
        for cabinet in 1...cabinets {
            let label = UILabel()
            label.text = "\(cabinet)"
            label.font = Design.Font.medium(18)
            label.sizeToFit()
            label.textColor = Design.Color.white
            headerView.addSubview(label)
            cabinetLabels.append(label)
        }
    }
    
    private func addCabinets(_ cabinets: Int) {
        for _ in 1...cabinets {
            let cabinetView = UIView()
            addSubview(cabinetView)
            cabinetViews.append(cabinetView)
        }
    }
    
    private func addDoctorSchedule(_ schedule: DoctorSchedule) {
        let doctorView = DoctorScheduleView(schedule)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        doctorView.transformArea.addGestureRecognizer(pan)
        cabinetViews[schedule.cabinet - 1].addSubview(doctorView)
        doctorViews.append(doctorView)
    }
    
//    func changeSchedule(_ schedule: inout DoctorSchedule, by interval: CGFloat) {
//        schedule.startingTime += TimeInterval(interval * 60)
//        schedule.endingTime += TimeInterval(interval * 60)
//    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let tY = translation.y - translation.y.truncatingRemainder(dividingBy: quarterHourHeight / 3)
        guard let doctorView = gesture.view?.superview as? DoctorScheduleView else { return }
        guard let cabinetView = doctorView.superview else { return }
        switch gesture.state {
        case .began:
            originalLocation = doctorView.frame.origin
        case .changed:
            let minTY = -originalLocation.y
            let maxTY = cabinetView.frame.height - originalLocation.y - doctorView.frame.height - 1
            doctorView.frame.origin.y = originalLocation.y + max(min(tY, maxTY), minTY)
            transformAction?(doctorView, doctorView.frame.origin.y)
//        case .ended:
//            for index in doctorViews.indices {
//                if doctorViews[index] == doctorView {
//                    changeSchedule(&schedules[index], by: tY)
//                }
//            }
        default: break
        }
    }
}

extension GraphicTableView {
    enum Size { 
        static let minuteHeight: CGFloat = 2
        static let doctorViewOffset: CGFloat = 10
        static let timelineOffset: CGFloat = 9
        static let lineOffset: Int = 8
        static let headerHeight: CGFloat = 25
        static let timelineWidth: CGFloat = 45
    }
    
    var hourHeight: CGFloat {
        Size.minuteHeight * 60
    }
    var quarterHourHeight: CGFloat {
        Size.minuteHeight * 15
    }
}
