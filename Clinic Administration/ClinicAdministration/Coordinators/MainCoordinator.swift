//
//  MainCoordinator.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 16.04.2021.
//

import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let modules: Modules

    init(navigationController: UINavigationController, modules: Modules) {
        self.navigationController = navigationController
        self.modules = modules
    }

    func start() {
        scheduleCoordinator()
    }

    func scheduleCoordinator() {
        let child = ScheduleCoordinator(navigationController: navigationController, modules: modules)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}
