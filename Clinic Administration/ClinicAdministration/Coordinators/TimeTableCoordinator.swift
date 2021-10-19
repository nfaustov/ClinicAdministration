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
        let (viewController, module) = modules.timeTable(selectedSchedule: nil)
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

extension TimeTableCoordinator: CalendarSubscription {
    func routeToCalendar(didFinish: @escaping (Date?) -> Void) {
        let (viewController, module) = modules.calendar()
        module.didFinish = didFinish
        navigationController.present(viewController, animated: true)
    }
}

// MARK: - GraphicTimeTableSubscription

extension TimeTableCoordinator: GraphicTimeTableSubscription {
    func routeToGraphicTimeTable(onDate: Date, didFinish: @escaping (Date?) -> Void) {
        let (viewController, module) = modules.graphicTimeTable(onDate)
        module.coordinator = self
        module.didFinish = didFinish
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - DoctorsSearchSubscription

extension TimeTableCoordinator: DoctorsSearchSubscription {
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

extension TimeTableCoordinator: CreateScheduleSubscription {
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

extension TimeTableCoordinator: PickCabinetSubscription {
    func routeToPickCabinet(previouslyPicked: Int?, didFinish: @escaping (Int?) -> Void) {
        let (viewController, module) = modules.pickCabinet(selected: previouslyPicked)
        module.didFinish = didFinish
        customPresent(viewController)
    }
}

// MARK: - GraphicTimeTablePreviewSubscription

extension TimeTableCoordinator: GraphicTimeTablePreviewSubscription {
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

extension TimeTableCoordinator: SchedulesListSubscription {
    func routeToSchedulesList(for doctor: Doctor, didFinish: @escaping (DoctorSchedule?) -> Void) {
        let (viewController, module) = modules.schedulesList(for: doctor)
        module.didFinish = { [navigationController] schedule in
            navigationController.popViewController(animated: true)
            didFinish(schedule)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}
