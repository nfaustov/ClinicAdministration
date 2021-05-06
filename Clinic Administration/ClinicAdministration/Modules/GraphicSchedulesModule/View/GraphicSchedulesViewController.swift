//
//  GraphicSchedulesViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.05.2021.
//

import UIKit

class GraphicSchedulesViewController: UIViewController {
    typealias PresenterType = GraphicSchedulesPresentation
    var presenter: PresenterType!

    var date: Date!

    private var graphicTimeTableView: GraphicTimeTableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = false

        view.backgroundColor = Design.Color.lightGray

        graphicTimeTableView = GraphicTimeTableView(date: date)
        view.addSubview(graphicTimeTableView)

        setupConstraints()

        presenter.didSelected(date: date)
    }

    private func setupConstraints() {
        graphicTimeTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            graphicTimeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            graphicTimeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            graphicTimeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            graphicTimeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - GraphicSchedulesDisplaying

extension GraphicSchedulesViewController: GraphicSchedulesDisplaying {
    func applySchedules(_ schedules: [DoctorSchedule]) {
        graphicTimeTableView.updateTable(with: schedules)
    }
}
