//
//  AdminPanelCoordinator.swift
//  ClinicAdministration
//
//  Created by Николай Фаустов on 14.02.2023.
//

import UIKit

final class AdminPanelCoordinator: Coordinator {
    weak var parentCoordinator: MainCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let modules: Modules

    init(navigationController: UINavigationController, modules: Modules) {
        self.navigationController = navigationController
        self.modules = modules
    }

    func start() {
        let (viewController, module) = modules.adminPanel()
        module.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}
