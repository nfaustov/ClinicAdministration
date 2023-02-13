//
//  GraphicTimeTableView.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 06.05.2021.
//

import UIKit

protocol GraphicTimeTableViewDelegate: AnyObject {
    func scheduleDidChanged(_ schedule: DoctorSchedule)
}

final class GraphicTimeTableView: UIView {
    private let vScrollView = UIScrollView()
    private let hScrollView = UIScrollView()

    private let headerView = UIView()

    private var timelineHeight: CGFloat {
        guard let tableViewCloseHour = tableView.close.hour,
              let tableViewOpeningHour = tableView.opening.hour else { return 0 }

        return CGFloat(tableViewCloseHour - tableViewOpeningHour) * tableView.hourHeight + tableView.quarterHourHeight
    }
    private var tableViewHeight: CGFloat {
        timelineHeight + 10
    }
    private var tableViewWidth: CGFloat {
        GraphicTableView.Size.timelineWidth + (UIScreen.main.bounds.width - GraphicTableView.Size.timelineWidth) /
            3 * CGFloat(Settings.cabinets)
    }

    private var hScrollViewHeightConstraint = NSLayoutConstraint()
    private var timeTableViewHeightConstraint = NSLayoutConstraint()
    private var timelineHeightConstraint = NSLayoutConstraint()

    private var tableView: GraphicTableView!
    private var timelineView: TimelineView!

    weak var delegate: GraphicTimeTableViewDelegate?

    var date: Date

    init(date: Date) {
        self.date = date
        super.init(frame: .zero)

        backgroundColor = Color.secondaryBackground
        layer.cornerRadius = Design.CornerRadius.large

        vScrollView.showsVerticalScrollIndicator = false
        hScrollView.showsHorizontalScrollIndicator = false
        hScrollView.isPagingEnabled = true
        hScrollView.bounces = false
        hScrollView.delegate = self

        tableView = GraphicTableView(date: date, transformAction: scheduleTransform(doctorView:))
        tableView.delegate = self
        timelineView = TimelineView(respectiveTo: tableView)

        addSubview(vScrollView)
        hScrollView.addSubview(tableView)
        vScrollView.addSubview(hScrollView)
        vScrollView.addSubview(timelineView)

        setupHeader()
        setupCabinetLabels()

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    func updateTable(with newSchedules: [DoctorSchedule]) {
        tableView.reload(with: date, schedules: newSchedules)
        timelineView.tableView = tableView
        hScrollViewHeightConstraint.constant = tableViewHeight
        timeTableViewHeightConstraint.constant = tableViewHeight
        timelineHeightConstraint.constant = timelineHeight
    }

    func addSchedules(_ schedules: [DoctorSchedule]) {
        tableView.addSchedules(schedules)
    }

    private func setupHeader() {
        addSubview(headerView)
        headerView.backgroundColor = Color.secondaryFill
        headerView.layer.cornerRadius = Design.CornerRadius.large
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: GraphicTableView.Size.headerHeight)
        ])
    }

    private func setupCabinetLabels() {
        for cabinet in 1...Settings.cabinets {
            let label = Label.titleLarge(color: Color.lightLabel, withText: "\(cabinet)")
            label.sizeToFit()
            headerView.addSubview(label)

            label.translatesAutoresizingMaskIntoConstraints = false

            let cabinetViewWidth = (tableViewWidth - GraphicTableView.Size.timelineWidth) / CGFloat(Settings.cabinets)
            let offsetX = GraphicTableView.Size.timelineWidth + cabinetViewWidth / 2 * CGFloat((cabinet - 1) * 2 + 1)

            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: headerView.leadingAnchor, constant: offsetX),
                label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
        }
    }

    private func setupConstraints() {
        for view in [tableView, timelineView, hScrollView, vScrollView] {
            view?.translatesAutoresizingMaskIntoConstraints = false
        }

        hScrollViewHeightConstraint = hScrollView.frameLayoutGuide.heightAnchor
            .constraint(equalToConstant: tableViewHeight)
        timeTableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: tableViewHeight)
        timelineHeightConstraint = timelineView.heightAnchor.constraint(equalToConstant: timelineHeight)

        NSLayoutConstraint.activate([
            vScrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            vScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            vScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            vScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            hScrollView.topAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.topAnchor),
            hScrollView.leadingAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.leadingAnchor),
            hScrollView.trailingAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.trailingAnchor),
            hScrollView.bottomAnchor.constraint(equalTo: vScrollView.contentLayoutGuide.bottomAnchor),
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
}

// MARK: - GraphicTableViewDelegate

extension GraphicTimeTableView: GraphicTableViewDelegate {
    func scheduleDidChanged(_ schedule: DoctorSchedule) {
        delegate?.scheduleDidChanged(schedule)
    }
}

// MARK: - UIScrollViewDelegate

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
