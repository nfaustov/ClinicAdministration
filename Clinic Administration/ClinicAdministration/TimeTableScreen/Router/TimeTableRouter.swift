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

extension TimeTableRouter: TimeTableRouterInput {
    func routeToGraphicTimeTableScreen(onDate: Date) {
        let graphicTimeTableViewController = GraphicTimeTableViewController()
        viewController.navigationController?.present(graphicTimeTableViewController, animated: true)
    }
}
