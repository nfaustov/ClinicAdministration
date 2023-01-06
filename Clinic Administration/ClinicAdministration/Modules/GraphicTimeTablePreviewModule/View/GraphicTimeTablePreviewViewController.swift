//
//  GraphicTimeTablePreviewViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 05.05.2021.
//

import UIKit

class GraphicTimeTablePreviewViewController: UIViewController {
    typealias PresenterType = GraphicTimeTablePreviewPresentation
    var presenter: PresenterType!

    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(Design.Color.chocolate, for: .normal)
        button.titleLabel?.font = Design.Font.robotoFont(ofSize: 15, weight: .medium)
        button.backgroundColor = Design.Color.white
        button.layer.cornerRadius = Design.CornerRadius.small
        button.layer.shadowColor = Design.Color.brown.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.2
        return button
    }()

    private var date: Date {
        newSchedule.starting
    }

    private var graphicTimeTableView: GraphicTimeTableView!

    var newSchedule: DoctorSchedule!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = false

        view.backgroundColor = Design.Color.lightGray

        graphicTimeTableView = GraphicTimeTableView(date: date)
        graphicTimeTableView.delegate = self
        view.addSubview(graphicTimeTableView)
        view.addSubview(confirmButton)

        let tap = UITapGestureRecognizer(target: self, action: #selector(confirmSchedule))
        confirmButton.addGestureRecognizer(tap)

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.didSelected(date: date)
    }

    private func setupConstraints() {
        graphicTimeTableView.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            confirmButton.widthAnchor.constraint(equalToConstant: 150),
            confirmButton.heightAnchor.constraint(equalToConstant: 30),

            graphicTimeTableView.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: 12),
            graphicTimeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            graphicTimeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            graphicTimeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func confirmSchedule() {
        presenter.saveNewSchedule(newSchedule)
    }
}

// MARK: - GraphicTimeTableViewDelegate

extension GraphicTimeTablePreviewViewController: GraphicTimeTableViewDelegate {
    func scheduleDidChanged(_ schedule: DoctorSchedule) {
        if schedule.id == newSchedule.id {
            presenter.updateNewSchedule(schedule)
        } else {
            presenter.updateSchedule(schedule)
        }
    }
}

// MARK: - GraphicTimeTablePreviewView

extension GraphicTimeTablePreviewViewController: GraphicTimeTablePreviewView {
    func applySchedules(_ schedules: [DoctorSchedule]) {
        graphicTimeTableView.updateTable(with: schedules)
    }

    func errorAlert(message: String) {
        let alert = AlertsFactory.makeError(message: message)
        present(alert, animated: true)
    }

    func successAlert(message: String) {
        let alert = AlertsFactory.makeSuccess(message: message)
        present(alert, animated: true)
    }
}
