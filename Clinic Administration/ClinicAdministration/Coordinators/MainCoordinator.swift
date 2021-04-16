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

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
//        let viewController = TimeTableBuilder.build()
//        viewcontroller.coordinator = self
//        navigationController.pushViewController(viewController, animated: true)
    }
}
