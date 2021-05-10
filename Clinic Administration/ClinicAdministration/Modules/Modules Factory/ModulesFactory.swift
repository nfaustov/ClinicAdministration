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
        view.date = date
        let interactor = GraphicTimeTableInteractor()
        let presenter = GraphicTimeTablePresenter(view: view, interactor: interactor)

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

    func pickDoctor(selected doctor: Doctor?) -> (UIViewController, PickDoctorModule) {
        let view = PickDoctorViewController()
        view.selectedDoctor = doctor
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

    func pickCabinet(selected cabinet: Int?) -> (UIViewController, PickCabinetModule) {
        let view = PickCabinetViewController()
        view.selectedCabinet = cabinet
        let presenter = PickCabinetPresenter(view: view)

        return (view, presenter)
    }

    func addSchedule(_ schedule: DoctorSchedule) -> (UIViewController, AddScheduleModule) {
        let view = AddScheduleViewController()
        view.newSchedule = schedule
        let interactor = AddScheduleInteractor()
        let presenter = AddSchedulePresenter(view: view, interactor: interactor)

        return (view, presenter)
    }
}
