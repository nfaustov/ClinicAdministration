//
//  TimeTableRouter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import UIKit
import CalendarControl

final class TimeTableRouter {
    let viewController: UIViewController
    weak var output: TimeTableRouterOutput!

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension TimeTableRouter: TimeTableRouting {
    func routeToGraphicTimeTableScreen(onDate: Date) {
        let graphicTimeTableViewController = GraphicTimeTableViewController()
        viewController.navigationController?.present(graphicTimeTableViewController, animated: true)
    }

    func routeToCalendarViewController() {
        let calendarViewController = CalendarViewController()
        viewController.present(calendarViewController, animated: true)
        calendarViewController.delegate = self
    }
}

extension TimeTableRouter: CalendarViewControllerDelegate {
    func cancelSelection() {
        // TODO: - return DatePicker selector to the last state
    }

    func selectedDate(_ date: Date) {
        output.selectedDate(date)
    }
}
