//
//  PatientCoordinator.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 26.12.2022.
//

import UIKit

final class PatientCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let modules: Modules

    init(navigationController: UINavigationController, modules: Modules) {
        self.navigationController = navigationController
        self.modules = modules
    }
}

// MARK: - PatientAppointmentSubscription

extension PatientCoordinator: PatientAppointmentSubscription {
    func routeToPatientAppointment(
        schedule: DoctorSchedule,
        appointment: PatientAppointment,
        didFinish: @escaping (DoctorSchedule?) -> Void
    ) {
        let (viewController, module) = modules.patientAppointment(schedule: schedule, appointment: appointment)
        module.coordinator = self
        module.didFinish = { [navigationController] schedule in
            navigationController.popViewController(animated: true)
            didFinish(schedule)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - PatientSearchSubscription

extension PatientCoordinator: PatientsSearchSubscription {
    func routeToPatientsSearch(didFInish: @escaping (Patient?) -> Void) {
        let (viewController, module) = modules.patientsSearch()
        module.didFinish = { [navigationController] patient in
            navigationController.popViewController(animated: true)
            didFInish(patient)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - PatientCardSubscription

extension PatientCoordinator: PatientCardSubscription {
    func routeToPatientCard(patient: Patient) {
        let (viewController, module) = modules.patientCard(patient: patient)
        module.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}
