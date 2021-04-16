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

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

// MARK: - GraphicTimeTableRouting

extension GraphicTimeTableRouter: GraphicTimeTableRouting {
    func routeToCalendar(_ calendarViewController: UIViewController) {
        viewController.present(calendarViewController, animated: true)
    }
}
