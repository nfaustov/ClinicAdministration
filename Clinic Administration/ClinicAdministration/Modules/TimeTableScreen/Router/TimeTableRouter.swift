//
//  TimeTableRouter.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 25.03.2021.
//

import UIKit

final class TimeTableRouter {
    let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

// MARK: - TimeTableRouting

extension TimeTableRouter: TimeTableRouting {
    func routeToGraphicTimeTableScreen(onDate date: Date) {
        let graphicTimeTableViewController = GraphicTimeTableBuilder.build(with: date)
        viewController.navigationController?.present(graphicTimeTableViewController, animated: true)
    }

    func routeToCalendar(_ calendarViewController: UIViewController) {
        viewController.present(calendarViewController, animated: true)
    }
}
