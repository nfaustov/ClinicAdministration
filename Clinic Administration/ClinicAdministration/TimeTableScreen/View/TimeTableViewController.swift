//
//  TimeTableViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import UIKit
import Extensions
import Design

final class TimeTableViewController: UIViewController {
    private var timeTableView: TimeTableView? {
        viewIfLoaded as? TimeTableView
    }

    var date = Date().addingTimeInterval(172_800)

    override func loadView() {
        view = TimeTableView(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let timeTableView = timeTableView else { return }

        let router = TimeTableRouter()
        let interactor = TimeTableInteractor()
        let presenter = TimeTablePresenter(view: timeTableView, router: router, interactor: interactor)
        timeTableView.output = presenter
        interactor.output = presenter
        presenter.viewDidLoad(with: date)
    }
}
