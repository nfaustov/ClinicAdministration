//
//  Coordinator.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 16.04.2021.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
