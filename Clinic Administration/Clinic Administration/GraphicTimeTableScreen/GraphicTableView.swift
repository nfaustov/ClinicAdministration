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
    
    private let dataSource = TimeTableDataSource()
    
    private var schedules: [DoctorSchedule] {
        return dataSource.filteredSchedules(for: date)
    }

    var cabinets = 5
    
    private let headerView = UIView()
    private let footerView = UIView()
    
    private var cabinetViews = [UIView]()
    private var cabinetLabels = [UILabel]()
    
    private(set) var doctorViews = [DoctorScheduleView]()
    
    private var originalLocation = CGPoint.zero
    private var minutesInterval = CGFloat.zero
    
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
        // Выводим пересекающиеся расписания на передний план.
        moveIntersectionsToFront()
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
        // При перезагрузке экрана выводим пересекающиеся расписания на передний план.
        moveIntersectionsToFront()
        
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
        let doctorView = DoctorScheduleView(schedule, minuteHeight: Size.minuteHeight,
                                            intersectionDetection: detectIntersection(for:), moveToFrontAction: { [weak self] doctorView in
                                                // В состоянии редактирования или пересечения вью доктора перемещается на передний план.
                                                self?.cabinetViews[schedule.cabinet - 1].bringSubviewToFront(doctorView)
        })
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        doctorView.transformArea.addGestureRecognizer(pan)
        cabinetViews[schedule.cabinet - 1].addSubview(doctorView)
        doctorViews.append(doctorView)
    }

    /// Метод, который выясняет является ли расписание пересекающимся.
    /// - Parameter schedule: Проверяемое расписание доктора.
    /// - Returns: true, если расписание находится в списке пересекающихся в `TimeTableDataSource`
    private func detectIntersection(for schedule: DoctorSchedule) -> Bool {
        /*
         Для начала в dataSource.updateSchedule проверяем изменялось(перемещалось) ли расписание, если да, то
         обновляем его в dataSource и в этом случае попадаем в блок updated.
         Поскольку перемещается только одно расписание, то другие проверять не нужно.
         Тем более, это вызовет бесконечный цикл вызовов этого метода.
        */
        dataSource.updateSchedule(schedule, updated: { [weak self] in
            guard let self = self else { return }
            
            let cabinetSchedules = self.schedules.filter({ $0.cabinet == schedule.cabinet })
            for doctorSchedule in cabinetSchedules {
                if doctorSchedule == schedule { continue }
                let doctorView = self.doctorViews.first(where: { $0.schedule == doctorSchedule })
                /*
                Проверяем все расписания кроме того, которое вызвало этот метод
                и устанавливаем им нужные состояния.
                checkState() заставит остальные вью докторов в кабинете также вызвать этот метод, но уже не попадая в блок updated
                */
                doctorView?.checkState()
            }
        })
        // Проверяем не находится ли вью доктора в списке пересекающихся.
        let intersectedSchedules = dataSource.intersectedSchedules(for: date).filter({ $0.cabinet == schedule.cabinet })
        return intersectedSchedules.contains(schedule)
    }
    
    /// Данный метод перемещает все пересекающиеся экземпляры `DoctorScheduleView` на передний план.
    ///
    /// Используется только в `init` и `reloadData`.
    private func moveIntersectionsToFront() {
        for schedule in dataSource.intersectedSchedules(for: date) {
            if let doctorView = self.doctorViews.first(where: { $0.schedule == schedule }) {
                cabinetViews[schedule.cabinet - 1].bringSubviewToFront(doctorView)
            }
        }
    }
    
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
            // Переводим translation в минуты.
            minutesInterval = max(min(tY, maxTY), minTY) / Size.minuteHeight
            transformAction?(doctorView, doctorView.frame.origin.y)
        case .ended:
            // Меняем расписание доктора.
            doctorView.editSchedule(options: [.endingTime, .startingTime], by: TimeInterval(minutesInterval * 60))
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
