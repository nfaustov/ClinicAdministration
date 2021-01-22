//
//  GraphicTimeTableViewController.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 09.11.2020.
//

import UIKit

final class GraphicTimeTableViewController: UIViewController {

    private var graphicTimeTableView: GraphicTimeTableView? {
        return viewIfLoaded as? GraphicTimeTableView
    }

    var date = Date().addingTimeInterval(172800)

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
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "CalendarViewController")
                as? CalendarViewController else { return }
        present(viewController, animated: true)
        viewController.delegate = graphicTimeTableView?.datePicker
    }
}
