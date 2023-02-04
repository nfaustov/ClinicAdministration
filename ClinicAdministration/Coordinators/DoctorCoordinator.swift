//
//  DoctorCoordinator.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 06.01.2023.
//

import UIKit

final class DoctorCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let modules: Modules

    init(navigationController: UINavigationController, modules: Modules) {
        self.navigationController = navigationController
        self.modules = modules
    }
}

// MARK: - DoctorSearchSubscription

extension DoctorCoordinator: DoctorsSearchSubscription {
    func routeToDoctorsSearch(didFinish: @escaping (Doctor?) -> Void) {
        let (viewController, module) = modules.doctorsSearch()
        module.didFinish = { [navigationController] doctor in
            navigationController.popViewController(animated: true)
            didFinish(doctor)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}
