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

    func adminPanelCoordinator() {
        let child = AdminPanelCoordinator(navigationController: navigationController, modules: modules)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func scheduleCoordinator() {
        let child = ScheduleCoordinator(navigationController: navigationController, modules: modules)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func patientCoordinator() {
        let child = PatientCoordinator(navigationController: navigationController, modules: modules)
        child.parentCoordinator = self
        childCoordinators.append(child)
        // MOCK
        let patient = Patient(
            secondName: "Фаустов",
            firstName: "Николай",
            patronymicName: "Игоревич",
            phoneNumber: "8 (999) 999-99-99"
        )
        //
        child.routeToPatientCard(patient: patient)
    }

    func doctorCoordinator() {
        let child = DoctorCoordinator(navigationController: navigationController, modules: modules)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.routeToDoctorsSearch { _ in }
    }
}
