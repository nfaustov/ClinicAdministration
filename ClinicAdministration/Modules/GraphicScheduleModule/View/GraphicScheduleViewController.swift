//
//  GraphicScheduleViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import UIKit

final class GraphicScheduleViewController: UIViewController {
    typealias PresenterType = GraphicSchedulePresentation
    var presenter: PresenterType!

    var date: Date! {
        didSet {
            guard let graphicTimeTableView = graphicTimeTableView else { return }

            graphicTimeTableView.date = date
        }
    }

    var schedules: [DoctorSchedule]!

    private var datePicker: DatePicker!
    private var graphicTimeTableView: GraphicTimeTableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.background

        datePicker = DatePicker(
            selectedDate: date,
            dateAction: changeDate(to:),
            calendarAction: presenter.pickDateInCalendar
        )
        graphicTimeTableView = GraphicTimeTableView(date: date)
        graphicTimeTableView.delegate = self

        view.addSubview(datePicker)
        view.addSubview(graphicTimeTableView)

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.didSelected(date: date)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        presenter.didFinish(with: date)
    }

    private func setupConstraints() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        graphicTimeTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            datePicker.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 90),

            graphicTimeTableView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 25),
            graphicTimeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            graphicTimeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            graphicTimeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func changeDate(to newDate: Date) {
        date = newDate
        presenter.didSelected(date: date)
    }
}

// MARK: - GraphicTimeTableViewDelegate

extension GraphicScheduleViewController: GraphicTimeTableViewDelegate {
    func scheduleDidChanged(_ schedule: DoctorSchedule) {
        presenter.updateSchedule(schedule)
    }
}

// MARK: - GraphicScheduleDisplaying

extension GraphicScheduleViewController: GraphicScheduleView {
    func updateTableView(with schedules: [DoctorSchedule]) {
        if self.schedules != nil {
            graphicTimeTableView.updateTable(with: schedules)
        } else {
            self.schedules = schedules
            graphicTimeTableView.addSchedules(schedules)
        }
    }

    func calendarPicked(date: Date?) {
        datePicker.changeDate(date)
    }
}
