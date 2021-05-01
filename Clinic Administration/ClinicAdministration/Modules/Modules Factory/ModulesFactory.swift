//
//  ModulesFactory.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.04.2021.
//

import UIKit

final class ModulesFactory: Modules {
    func timeTable() -> (UIViewController, TimeTableModule) {
        let view = TimeTableViewController()
        let interactor = TimeTableInteractor()
        let presenter = TimeTablePresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func graphicTimeTable(_ date: Date) -> (UIViewController, GraphicTimeTableModule) {
        let view = GraphicTimeTableViewController()
        let interactor = GraphicTimeTableInteractor()
        let presenter = GraphicTimeTablePresenter(view: view, interactor: interactor)
        presenter.didSelected(date: date)

        return (view, presenter)
    }

    func calendar() -> (UIViewController, CalendarModule) {
        let view = CalendarViewController()
        let presenter = CalendarPresenter(view: view)

        return (view, presenter)
    }

    func createSchedule(with date: Date) -> (UIViewController, CreateScheduleModule) {
        let view = CreateScheduleViewController()
        view.date = date
        let interactor = CreateScheduleInteractor()
        let presenter = CreateSchedulePresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func pickDoctor() -> (UIViewController, PickDoctorModule) {
        let view = PickDoctorViewController()
        let presenter = PickDoctorPresenter(view: view)

        return (view, presenter)
    }

    func pickTimeInterval(
        availableOnDate date: Date,
        selected interval: (Date, Date)?
    ) -> (UIViewController, PickTimeIntervalModule) {
        let view = PickTimeIntervalViewController()
        view.date = date
        view.selectedInterval = interval
        let presenter = PickTimeIntervalPresenter(view: view)

        return (view, presenter)
    }

    func pickCabinet() -> (UIViewController, PickCabinetModule) {
        let view = PickCabinetViewController()
        let presenter = PickCabinetPresenter(view: view)

        return (view, presenter)
    }
}
