//
//  TimeTableCoordinator.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 21.04.2021.
//

import UIKit

final class TimeTableCoordinator: Coordinator {
    weak var parentCoordinator: MainCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let modules: Modules

    init(navigationController: UINavigationController, modules: Modules) {
        self.navigationController = navigationController
        self.modules = modules
    }

    func start() {
        let (viewController, module) = modules.timeTable()
        module.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
}

// MARK: - CalendarSubscription

extension TimeTableCoordinator: CalendarSubscription {
    func routeToCalendar(didFinish: @escaping ((Date?) -> Void)) {
        let (viewController, module) = modules.calendar()
        module.coordinator = self
        module.didFinish = didFinish
        navigationController.present(viewController, animated: true)
    }
}

// MARK: - GraphicScheduling

extension TimeTableCoordinator: GraphicTimeTableSubscription {
    func routeToGraphicTimeTable(onDate: Date, didFinish: @escaping ((Date?) -> Void)) {
        let (viewController, module) = modules.graphicTimeTable(onDate)
        module.coordinator = self
        module.didFinish = didFinish
        navigationController.pushViewController(viewController, animated: true)
    }
}
