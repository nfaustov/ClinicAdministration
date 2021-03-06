//
//  GraphicTimeTableView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.12.2020.
//

import UIKit

protocol GraphicTimeTableViewDelegate: AnyObject {
    func dateChanged(_ date: Date)

    func openCalendar()
}

final class GraphicTimeTableView: UIView {
    private let vScrollView = UIScrollView()
    private let hScrollView = UIScrollView()

    private var timelineHeight: CGFloat {
        guard let tableViewCloseHour = tableView.close.hour,
              let tableViewOpeningHour = tableView.opening.hour else { return 0 }
        return CGFloat(tableViewCloseHour - tableViewOpeningHour) * tableView.hourHeight + tableView.quarterHourHeight
    }
    private var tableViewHeight: CGFloat {
        timelineHeight + 2 * GraphicTableView.Size.headerHeight
    }

    private var contentOffsetBounds: CGRect {
        let width = vScrollView.contentSize.width - vScrollView.frame.width
        let height = vScrollView.contentSize.height - vScrollView.frame.height
        return CGRect(x: 0, y: 0, width: width, height: height)
    }

    private var hScrollViewHeightConstraint = NSLayoutConstraint()
    private var timeTableViewHeightConstraint = NSLayoutConstraint()
    private var timelineHeightConstraint = NSLayoutConstraint()

    weak var delegate: GraphicTimeTableViewDelegate?

    private var tableView: GraphicTableView!
    private var timelineView: TimelineView!
    private(set) var datePicker: DatePicker!

    init(date: Date) {
        super.init(frame: .zero)

        backgroundColor = Design.Color.lightGray

        datePicker = DatePicker(selectedDate: date, dateAction: changeDate(to:), calendarAction: openCalendar)
        tableView = GraphicTableView(date: date, transformAction: scheduleTransform(doctorView:translation:))
        timelineView = TimelineView(respectiveTo: tableView)

        addSubview(vScrollView)
        vScrollView.showsVerticalScrollIndicator = false

        hScrollView.showsHorizontalScrollIndicator = false
        hScrollView.isPagingEnabled = true
        hScrollView.bounces = false
        hScrollView.delegate = self
        hScrollView.addSubview(tableView)
        vScrollView.addSubview(hScrollView)
        vScrollView.addSubview(timelineView)
        vScrollView.addSubview(datePicker)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        for view in [datePicker, tableView, timelineView, hScrollView, vScrollView] {
            view?.translatesAutoresizingMaskIntoConstraints = false
        }

        let screenWidth = UIScreen.main.bounds.width
        let tableViewWidth = GraphicTableView.Size.timelineWidth
            + (screenWidth - GraphicTableView.Size.timelineWidth) / 3 * CGFloat(Settings.cabinets)

        hScrollViewHeightConstraint = hScrollView.frameLayoutGuide.heightAnchor
            .constraint(equalToConstant: tableViewHeight)
        timeTableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: tableViewHeight)
        timelineHeightConstraint = timelineView.heightAnchor.constraint(equalToConstant: timelineHeight)

        NSLayoutConstraint.activate([
            vScrollView.topAnchor.constraint(equalTo: topAnchor),
            vScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            vScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            vScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            datePicker.topAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.topAnchor, constant: 16),
            datePicker.leadingAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.leadingAnchor, constant: 12),
            datePicker.trailingAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.trailingAnchor, constant: -12),
            datePicker.heightAnchor.constraint(equalToConstant: 90),

            hScrollView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 25),
            hScrollView.leadingAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.leadingAnchor),
            hScrollView.trailingAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.trailingAnchor),
            hScrollView.bottomAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.bottomAnchor, constant: -25),
            hScrollView.widthAnchor.constraint(equalTo: vScrollView.frameLayoutGuide.widthAnchor),
            hScrollViewHeightConstraint,

            tableView.topAnchor.constraint(equalTo: hScrollView.contentLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: hScrollView.contentLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: hScrollView.contentLayoutGuide.trailingAnchor),
            tableView.widthAnchor.constraint(equalToConstant: tableViewWidth),
            timeTableViewHeightConstraint,

            timelineView.topAnchor
                .constraint(equalTo: tableView.topAnchor, constant: GraphicTableView.Size.headerHeight),
            timelineView.leadingAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.leadingAnchor),
            timelineHeightConstraint,
            timelineView.widthAnchor.constraint(equalToConstant: GraphicTableView.Size.timelineWidth)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if hScrollView.contentOffset.x == 0 { return }

        for doctorView in tableView.doctorViews {
            let doctorViewOrigin = doctorView.convert(doctorView.frame.origin, to: tableView)
            if hScrollView.contentOffset.x > doctorViewOrigin.x {
                doctorView.alpha = 0
            }
        }
    }

    private func clampOffset(_ offset: CGPoint) -> CGPoint {
        offset.clamped(to: contentOffsetBounds)
    }

    private func changeDate(to newDate: Date) {
        tableView.date = newDate
        timelineView.tableView = tableView
        hScrollViewHeightConstraint.constant = tableViewHeight
        timeTableViewHeightConstraint.constant = tableViewHeight
        timelineHeightConstraint.constant = timelineHeight
        delegate?.dateChanged(newDate)
    }

    private func openCalendar() {
        delegate?.openCalendar()
    }

    private func scheduleTransform(doctorView: DoctorScheduleView, translation: CGFloat) {
        let updatedYOffset = translation

        let contentOffset = clampOffset(CGPoint(x: vScrollView.contentOffset.x, y: updatedYOffset))

        vScrollView.setContentOffset(contentOffset, animated: true)
    }
}

extension GraphicTimeTableView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == hScrollView {
            for doctorView in tableView.doctorViews {
                let doctorViewOrigin = doctorView.convert(doctorView.frame.origin, to: tableView)
                UIView.animate(withDuration: 0.1) {
                    if scrollView.contentOffset.x > doctorViewOrigin.x {
                        doctorView.alpha = 0
                    } else {
                        doctorView.alpha = 1
                    }
                }
            }
        }
    }
}

extension CGPoint {
    func clamped(to rect: CGRect) -> CGPoint {
        CGPoint(x: x.clamped(to: rect.minX...rect.maxX), y: y.clamped(to: rect.minY...rect.maxY))
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
