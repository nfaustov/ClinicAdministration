//
//  GraphicTimeTableRouter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 13.04.2021.
//

import UIKit
import CalendarControl

final class GraphicTimeTableRouter {
    let viewController: UIViewController
    weak var output: GraphicTimeTableRouterOutput!

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension GraphicTimeTableRouter: GraphicTimeTableRouting {
    func routeToCalendarViewController() {
        let calendarViewController = CalendarViewController()
        viewController.present(calendarViewController, animated: true)
        calendarViewController.delegate = self
    }
}

extension GraphicTimeTableRouter: CalendarViewControllerDelegate {
    func selectedDate(_ date: Date) {
        output.selectedDate(date)
    }

    func cancelSelection() {
        // TODO: - return DatePicker selector to the last state
    }
}
