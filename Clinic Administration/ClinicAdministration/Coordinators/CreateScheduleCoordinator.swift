//
//  CreateScheduleCoordinator.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 08.06.2021.
//

import UIKit

final class CreateScheduleCoordinator: Coordinator {
    weak var parentCoordinator: TimeTableCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let modules: Modules

    init(navigationController: UINavigationController, modules: Modules) {
        self.navigationController = navigationController
        self.modules = modules
    }

    func start() {
        let (viewController, module) = modules.createSchedule()
        module.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }

    private func customPresent(_ viewController: UIViewController, animated: Bool = true) {
        viewController.transitioningDelegate = viewController as? UIViewControllerTransitioningDelegate
        viewController.modalPresentationStyle = .custom
        navigationController.present(viewController, animated: animated)
    }
}

// MARK: - DoctorsSearchSubscription

extension CreateScheduleCoordinator: DoctorsSearchSubscription {
    func routeToDoctorsSearch(didFinish: @escaping (Doctor?) -> Void) {
        let (viewController, module) = modules.doctorsSearch()
        module.didFinish = { [navigationController] doctor in
            didFinish(doctor)
            navigationController.popViewController(animated: true)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - CalendarSubscription

extension CreateScheduleCoordinator: CalendarSubscription {
    func routeToCalendar(didFinish: @escaping (Date?) -> Void) {
        let (viewController, module) = modules.calendar()
        module.didFinish = didFinish
        navigationController.present(viewController, animated: true)
    }
}

// MARK: - PickTimeIntervalSubscription

extension CreateScheduleCoordinator: PickTimeIntervalSubscription {
    func routeToPickTimeInterval(
        date: Date,
        previouslyPicked: (Date, Date)?,
        didFinish: @escaping (Date?, Date?) -> Void
    ) {
        let (viewController, module) = modules.pickTimeInterval(availableOnDate: date, selected: previouslyPicked)
        module.didFinish = didFinish
        customPresent(viewController)
    }
}

// MARK: - PickCabinetSubscription

extension CreateScheduleCoordinator: PickCabinetSubscription {
    func routeToPickCabinet(previouslyPicked: Int?, didFinish: @escaping (Int?) -> Void) {
        let (viewController, module) = modules.pickCabinet(selected: previouslyPicked)
        module.didFinish = didFinish
        customPresent(viewController)
    }
}

// MARK: - GraphicTimeTablePreviewSubscription

extension CreateScheduleCoordinator: GraphicTimeTablePreviewSubscription {
    func routeToGraphicTimeTablePreview(_ schedule: DoctorSchedule, didFinish: @escaping (DoctorSchedule) -> Void) {
        let (viewController, module) = modules.graphicTimeTablePreview(schedule)
        module.didFinish = didFinish
        navigationController.pushViewController(viewController, animated: true)
    }
}
