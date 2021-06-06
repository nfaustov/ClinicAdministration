//
//  DoctorsSearchCoordinator.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 03.06.2021.
//

import UIKit

final class DoctorsSearchCoordinator: Coordinator {
    weak var parentCoordinator: TimeTableCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let modules: Modules

    init(navigationController: UINavigationController, modules: Modules) {
        self.navigationController = navigationController
        self.modules = modules
    }

    func start() {
        let (viewController, module) = modules.doctorsSearch()
        module.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}
