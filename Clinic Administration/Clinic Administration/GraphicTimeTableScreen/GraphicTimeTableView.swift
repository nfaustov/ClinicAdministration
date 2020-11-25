//
//  GraphicTimeTableView.swift
//  Clinic Administration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import UIKit

//protocol TimeTableViewDelegate: AnyObject {  // делегат для автоскролла, если расписание жестом перемещается к верхней или нижней точке экрана (пока не реализован)
//    func scheduleDidTransform(by y: CGFloat)
//}

class GraphicTimeTableView: UIView {
    
    var date: DateComponents { // перерисовываем таблицу если дата изменится
        didSet {
            setDate(date)
            setNeedsDisplay()
        }
    }
    
    private let calendar = Calendar.current
    
    private(set) var opening = DateComponents() // эти две переменные используются для рисования и лэйаута
    private(set) var close = DateComponents()
    
    private var schedules: [DoctorSchedule] {
        let dataSource = TimeTableDataSource() // класс где декодится JSON файл и хранятся все расписания врачей
        return dataSource.filterSchedules(for: date) // отбираем расписание врачей для каждой даты
    }

    var cabinets = 5 // в планах сделать эту переменную глобальной, с возможностью изменить ее на экране настроек в приложении
    
//    weak var delegate: TimeTableViewDelegate?
    
    private let headerView = UIView()
    private let footerView = UIView()
    
    private var cabinetViews = [UIView]()
    private var cabinetLabels = [UILabel]()
    
    private var timelineLabels = [UILabel]()
    
    private var doctorViews = [DoctorScheduleView]()
    
    private var originalLocation = CGPoint() // переменные для реализации pan gesture
    private var originalHeight = CGFloat()
    
    private func setDate(_ date: DateComponents) {
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
    
    init(date: DateComponents) {
        self.date = date
        super.init(frame: .zero)
        
        setDate(date)
        
        backgroundColor = Design.Color.white
        layer.cornerRadius = Design.Shape.largeCornerRadius
        layer.masksToBounds = true
        
        addSubview(headerView)
        headerView.backgroundColor = Design.Color.chocolate
        addSubview(footerView)
        footerView.backgroundColor = Design.Color.chocolate
        
        setupCabinetLabels(cabinets)
        addCabinets(cabinets)
        addTimeline()
        schedules.forEach { (schedule) in
            addDoctorSchedule(schedule)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() { // перезагружаем таблицу, когда дата изменится
        for label in timelineLabels { // обновляем временную шкалу
            label.removeFromSuperview()
            timelineLabels.remove(at: 0)
        }
        addTimeline()
        
        for doctorView in doctorViews { // обновляем расписания врачей
            doctorView.removeFromSuperview()
            doctorViews.remove(at: 0)
        }
        schedules.forEach { (schedule) in
            addDoctorSchedule(schedule)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let cabinetViewWidth = (bounds.width - Size.timelineWidth) / CGFloat(cabinets) // рассчитываем ширину каждого кабинета

        headerView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: Size.headerHeight)
        footerView.frame = CGRect(x: 0, y: bounds.height - Size.headerHeight, width: bounds.width, height: Size.headerHeight)
        
        for cabinet in 0..<cabinets {
            cabinetLabels[cabinet].center = CGPoint(x: Size.timelineWidth + cabinetViewWidth / 2 * CGFloat(cabinet * 2 + 1), y: headerView.frame.height / 2) // лэйаут для номера кабинета
            cabinetViews[cabinet].frame = CGRect(x: Size.timelineWidth + cabinetViewWidth * CGFloat(cabinet),
                                                 y: Size.headerHeight + quarterHourHeight,
                                                 width: cabinetViewWidth,
                                                 height: bounds.height - Size.headerHeight * 2 - quarterHourHeight)
            // вью кабинетов прозрачные, но они нужны как супервью для размещения и перемещения докторов
        }
        
        for index in schedules.indices {
            let timeIntervalFromOpening = calendar.dateComponents([.hour, .minute], // рассчитываем интервал от открытия дня до начала приема врача
                                                                  from: opening,
                                                                  to: schedules[index].startingTime)
            let timeIntervalFromStarting = calendar.dateComponents([.hour, .minute], // интервал от начала приема до конца приема врача
                                                                   from: schedules[index].startingTime,
                                                                   to: schedules[index].endingTime)
            
            let minutesFromOpening = CGFloat(timeIntervalFromOpening.hour! * 60 + timeIntervalFromOpening.minute!) // переводим в минуты
            let scheduleMinutes = CGFloat(timeIntervalFromStarting.hour! * 60 + timeIntervalFromStarting.minute!)
            
            doctorViews[index].frame = CGRect(x: Size.doctorViewOffset, // лэйаут для расписания врача
                                              y: minutesFromOpening * Size.minuteHeight,
                                              width: cabinetViewWidth - Size.doctorViewOffset * 2,
                                              height: scheduleMinutes * Size.minuteHeight)
        }
    }
    
    private func setupCabinetLabels(_ cabinets: Int) {
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
    
    private func addTimeline() {
        let hours = close.hour! - opening.hour!
        for hour in 0...hours {
            let step: CGFloat = (hour == hours) ? 1 : 0.25
            for quarterHour in stride(from: CGFloat(0), to: CGFloat(1), by: step) {
                let minutes = Int(60 * quarterHour)
                let label = UILabel()
                label.text = (minutes == 0) ? "\(opening.hour! + hour):00" : "\(opening.hour! + hour):\(minutes)"
                label.font = Design.Font.regular(14)
                label.sizeToFit()
                label.frame.origin = CGPoint(x: Size.timelineOffset, y: Size.headerHeight + quarterHourHeight * ((CGFloat(hour) + quarterHour) * 4 + 1) - label.frame.height)
                label.textColor = Design.Color.brown
                addSubview(label)
                timelineLabels.append(label)
            }
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
        doctorView.transformArea.addGestureRecognizer(pan) // у вью доктора есть 3 зоны, transformArea используется для перемещения, остальные для изменения размера расписания
        cabinetViews[schedule.cabinet - 1].addSubview(doctorView) // добавляем вью доктора в нужный кабинет
        doctorViews.append(doctorView)
    }
    
//    func changeSchedule(_ schedule: inout DoctorSchedule, by interval: CGFloat) {
//        schedule.startingTime += TimeInterval(interval * 60)
//        schedule.endingTime += TimeInterval(interval * 60)
//    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let tY = translation.y - translation.y.truncatingRemainder(dividingBy: quarterHourHeight / 3) // вью перемещается с шагом 5 минут (10 поинтов)
        guard let doctorView = gesture.view?.superview else { return }
        guard let cabinetView = doctorView.superview else { return }
        switch gesture.state {
        case .began:
            originalLocation = doctorView.frame.origin
        case .changed:
            let minTY = -originalLocation.y
            let maxTY = cabinetView.frame.height - originalLocation.y - doctorView.frame.height - 1
            doctorView.frame.origin.y = originalLocation.y + max(min(tY, maxTY), minTY) // ограничиваем вью от перемещения за пределы кабинета (временной шкалы)
//            delegate?.scheduleDidTransform(by: tY)
//        case .ended:
//            for index in doctorViews.indices {                    // в процессе разработки
//                if doctorViews[index] == doctorView {
//                    changeSchedule(&schedules[index], by: tY)
//                }
//            }
        default: break
        }
    }
}

extension GraphicTimeTableView {
    enum Size { 
        static let minuteHeight: CGFloat = 2
        static let doctorViewOffset: CGFloat = 10
        static let timelineOffset: CGFloat = 9
        static let lineOffset: Int = 8
        static let headerHeight: CGFloat = 25
        static let timelineWidth: CGFloat = 45
    }
    
    var hourHeight: CGFloat { // эти переменные используются во вью контроллере для лэйаута
        Size.minuteHeight * 60
    }
    var quarterHourHeight: CGFloat {
        Size.minuteHeight * 15
    }
}
