//
//  ScheduleCoordinator.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 21.04.2021.
//

import UIKit

final class ScheduleCoordinator: Coordinator {
    weak var parentCoordinator: MainCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let modules: Modules

    init(navigationController: UINavigationController, modules: Modules) {
        self.navigationController = navigationController
        self.modules = modules
    }

    func start() {
        let (viewController, module) = modules.schedule(selectedSchedule: nil)
        module.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }

    private func customPresent(_ viewController: UIViewController, animated: Bool = true) {
        viewController.transitioningDelegate = viewController as? UIViewControllerTransitioningDelegate
        viewController.modalPresentationStyle = .custom
        navigationController.present(viewController, animated: animated)
    }
}

// MARK: - CalendarSubscription

extension ScheduleCoordinator: CalendarSubscription {
    func routeToCalendar(didFinish: @escaping (Date?) -> Void) {
        let (viewController, module) = modules.calendar()
        module.didFinish = didFinish
        navigationController.present(viewController, animated: true)
    }
}

// MARK: - GraphicScheduleSubscription

extension ScheduleCoordinator: GraphicScheduleSubscription {
    func routeToGraphicSchedule(onDate: Date, didFinish: @escaping (Date?) -> Void) {
        let (viewController, module) = modules.graphicschedule(onDate)
        module.coordinator = self
        module.didFinish = didFinish
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - DoctorsSearchSubscription

extension ScheduleCoordinator: DoctorsSearchSubscription {
    func routeToDoctorsSearch(didFinish: @escaping (Doctor?) -> Void) {
        let (viewController, module) = modules.doctorsSearch()
        module.didFinish = { [navigationController] doctor in
            navigationController.popViewController(animated: true)
            didFinish(doctor)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - CreateScheduleSubscription

extension ScheduleCoordinator: CreateScheduleSubscription {
    func routeToCreateSchedule(for doctor: Doctor, onDate date: Date, didFinish: @escaping(DoctorSchedule?) -> Void) {
        let (viewController, module) = modules.createSchedule(for: doctor, onDate: date)
        module.coordinator = self
        module.didFinish = { [navigationController] schedule in
            navigationController.popViewController(animated: true)
            didFinish(schedule)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - PickCabinetSubscription

extension ScheduleCoordinator: PickCabinetSubscription {
    func routeToPickCabinet(previouslyPicked: Int?, didFinish: @escaping (Int?) -> Void) {
        let (viewController, module) = modules.pickCabinet(selected: previouslyPicked)
        module.didFinish = didFinish
        customPresent(viewController)
    }
}

// MARK: - GraphicTimeTablePreviewSubscription

extension ScheduleCoordinator: GraphicTimeTablePreviewSubscription {
    func routeToGraphicTimeTablePreview(_ schedule: DoctorSchedule, didFinish: @escaping (DoctorSchedule) -> Void) {
        let (viewController, module) = modules.graphicTimeTablePreview(schedule)
        module.didFinish = { [navigationController] schedule in
            navigationController.popViewController(animated: true)
            didFinish(schedule)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - SchedulesListSubscription

extension ScheduleCoordinator: SchedulesListSubscription {
    func routeToSchedulesList(for doctor: Doctor, didFinish: @escaping (DoctorSchedule?) -> Void) {
        let (viewController, module) = modules.schedulesList(for: doctor)
        module.didFinish = { [navigationController] schedule in
            navigationController.popViewController(animated: true)
            didFinish(schedule)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - PatientAppointmentSubscription

extension ScheduleCoordinator: PatientAppointmentSubscription {
    func routeToPatientAppointment(
        schedule: DoctorSchedule,
        appointment: PatientAppointment,
        didFinish: @escaping (DoctorSchedule?) -> Void
    ) {
        let child = PatientCoordinator(navigationController: navigationController, modules: modules)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.routeToPatientAppointment(schedule: schedule, appointment: appointment, didFinish: didFinish)
    }
}
