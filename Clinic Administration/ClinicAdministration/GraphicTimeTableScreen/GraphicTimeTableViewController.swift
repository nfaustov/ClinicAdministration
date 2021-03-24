//
//  GraphicTimeTableViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import UIKit
import CalendarControl

final class GraphicTimeTableViewController: UIViewController {
    private var graphicTimeTableView: GraphicTimeTableView? {
        viewIfLoaded as? GraphicTimeTableView
    }

    var date = Date().addingTimeInterval(172_800)

    override func loadView() {
        view = GraphicTimeTableView(date: date)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        graphicTimeTableView?.delegate = self
    }
}

extension GraphicTimeTableViewController: GraphicTimeTableViewDelegate {
    func dateChanged(_ date: Date) {
        self.date = date
    }

    func openCalendar() {
        let calendarViewController = CalendarViewController()
        present(calendarViewController, animated: true)
        calendarViewController.delegate = graphicTimeTableView?.datePicker
    }
}
