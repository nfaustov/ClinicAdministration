//
//  GraphicTimeTableViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import UIKit
import DatePicker
import Design

final class GraphicTimeTableViewController: UIViewController {
    var date: Date!
    var schedules: [DoctorSchedule]!

    var presenter: GraphicTimeTablePresentation!

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

    private var hScrollViewHeightConstraint = NSLayoutConstraint()
    private var timeTableViewHeightConstraint = NSLayoutConstraint()
    private var timelineHeightConstraint = NSLayoutConstraint()

    private var tableView: GraphicTableView!
    private var timelineView: TimelineView!
    private var datePicker: DatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Design.Color.lightGray

        datePicker = DatePicker(
            selectedDate: date,
            dateAction: changeDate(to:),
            calendarAction: presenter.calendarRequired
        )
        tableView = GraphicTableView(date: date, schedules, transformAction: scheduleTransform(doctorView:))
        timelineView = TimelineView(respectiveTo: tableView)

        view.addSubview(vScrollView)
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if hScrollView.contentOffset.x == 0 { return }

        for doctorView in tableView.doctorViews {
            let doctorViewOrigin = doctorView.convert(doctorView.frame.origin, to: tableView)
            if hScrollView.contentOffset.x > doctorViewOrigin.x {
                doctorView.alpha = 0
            }
        }
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
            vScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            vScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            datePicker.topAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.topAnchor, constant: 16),
            datePicker.leadingAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.leadingAnchor, constant: 12),
            datePicker.trailingAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.trailingAnchor, constant: -12),
            datePicker.heightAnchor.constraint(equalToConstant: 90),

            hScrollView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 25),
            hScrollView.leadingAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.leadingAnchor),
            hScrollView.trailingAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.trailingAnchor),
            hScrollView.bottomAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.bottomAnchor, constant: -10),
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

    private func scheduleTransform(doctorView: DoctorScheduleView) {
        let maxOriginY = vScrollView.contentSize.height - doctorView.frame.height
        let originYToVisible = min(doctorView.frame.origin.y + doctorView.frame.origin.y / 2, maxOriginY)
        let rectToVisible = CGRect(
            x: doctorView.frame.origin.x,
            y: originYToVisible,
            width: doctorView.frame.width,
            height: doctorView.frame.height
        )

        vScrollView.scrollRectToVisible(rectToVisible, animated: false)
    }

    private func changeDate(to newDate: Date) {
        date = newDate
        presenter.didSelected(date: date)
    }
}

extension GraphicTimeTableViewController: UIScrollViewDelegate {
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

extension GraphicTimeTableViewController: GraphicTimeTableDisplaying {
    func updateTableView(with newSchedules: [DoctorSchedule]) {
        if schedules != nil {
            tableView.reload(with: date, schedules: newSchedules)
            timelineView.tableView = tableView
            hScrollViewHeightConstraint.constant = tableViewHeight
            timeTableViewHeightConstraint.constant = tableViewHeight
            timelineHeightConstraint.constant = timelineHeight
        } else {
            schedules = newSchedules
        }
    }
}
