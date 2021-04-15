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

//MARK: - TimeTableRouting

extension TimeTableRouter: TimeTableRouting {
    func routeToGraphicTimeTableScreen(onDate date: Date) {
        let graphicTimeTableViewController = GraphicTimeTableBuilder.build(with: date)
        viewController.navigationController?.present(graphicTimeTableViewController, animated: true)
    }

    func routeToCalendarViewController() {
        let calendarViewController = CalendarViewController()
        viewController.present(calendarViewController, animated: true)
        calendarViewController.delegate = self
    }
}

// MARK: - CalendarViewControllerDelegate

extension TimeTableRouter: CalendarViewControllerDelegate {
    func selectedDate(_ date: Date) {
        output.selectedDate(date)
    }

    func cancelSelection() {
        // TODO: - return DatePicker selector to the last state
    }
}
