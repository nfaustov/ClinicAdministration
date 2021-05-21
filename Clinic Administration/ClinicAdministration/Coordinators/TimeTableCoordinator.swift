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
        let (viewController, module) = modules.timeTable()
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
    func routeToCalendar(didFinish: @escaping ((Date?) -> Void)) {
        let (viewController, module) = modules.calendar()
        module.didFinish = didFinish
        navigationController.present(viewController, animated: true)
    }
}

// MARK: - GraphicTimeTableSubscription

extension TimeTableCoordinator: GraphicTimeTableSubscription {
    func routeToGraphicTimeTable(onDate: Date, didFinish: @escaping ((Date?) -> Void)) {
        let (viewController, module) = modules.graphicTimeTable(onDate)
        module.coordinator = self
        module.didFinish = didFinish
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - AddScheduleSubscription

extension TimeTableCoordinator: AddScheduleSubscription {
    func routeToAddSchedule(_ schedule: DoctorSchedule) {
        let (viewController, module) = modules.addSchedule(schedule)
        module.didFinish = { self.navigationController.popToRootViewController(animated: true)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - CreateScheduleSubscription

extension TimeTableCoordinator: CreateScheduleSubscription {
    func routeToCreateSchedule(date: Date) {
        let (viewController, module) = modules.createSchedule(with: date)
        module.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - PickDoctorSubscription

extension TimeTableCoordinator: PickDoctorSubscription {
    func routeToPickDoctor(
        from doctors: [Doctor],
        previouslyPicked: Doctor?,
        didFinish: @escaping ((Doctor?) -> Void)
    ) {
        let (viewController, module) = modules.pickDoctor(from: doctors, selected: previouslyPicked)
        module.didFinish = didFinish
        customPresent(viewController)
    }
}

// MARK: - PickTimeIntervalSubscription

extension TimeTableCoordinator: PickTimeIntervalSubscription {
    func routeToPickTimeInterval(
        date: Date,
        previouslyPicked: (Date, Date)?,
        didFinish: @escaping ((Date?, Date?) -> Void)
    ) {
        let (viewController, module) = modules.pickTimeInterval(availableOnDate: date, selected: previouslyPicked)
        module.didFinish = didFinish
        customPresent(viewController)
    }
}

// MARK: - PickCabinetSubscription

extension TimeTableCoordinator: PickCabinetSubscription {
    func routeToPickCabinet(previouslyPicked: Int?, didFinish: @escaping ((Int?) -> Void)) {
        let (viewController, module) = modules.pickCabinet(selected: previouslyPicked)
        module.didFinish = didFinish
        customPresent(viewController)
    }
}
