//
//  ModulesFactory.swift
//  ClinicAdministration
//
//  Created by Nikolai Faustov on 22.04.2021.
//

import UIKit

final class ModulesFactory: Modules {
    private let dependencies: DatabaseDependencies & HttpServiceDependencies

    init(dependencies: DatabaseDependencies & HttpServiceDependencies) {
        self.dependencies = dependencies
    }

    func timeTable(selectedSchedule: DoctorSchedule?) -> (UIViewController, TimeTableModule) {
        let view = TimeTableViewController()
        if let selectedSchedule = selectedSchedule {
            view.newSchedule = selectedSchedule
            view.date = selectedSchedule.startingTime
        }
        let interactor = TimeTableInteractor()
        interactor.database = dependencies.doctorsDatabase
        let presenter = TimeTablePresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func graphicTimeTable(_ date: Date) -> (UIViewController, GraphicTimeTableModule) {
        let view = GraphicTimeTableViewController()
        view.date = date
        let interactor = GraphicTimeTableInteractor()
        interactor.database = dependencies.doctorsDatabase
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
        interactor.database = dependencies.doctorsDatabase
        let presenter = CreateSchedulePresenter(view: view, interactor: interactor)

        return (view, presenter)
    }

    func pickDoctor(from doctors: [Doctor], selected doctor: Doctor?) -> (UIViewController, PickDoctorModule) {
        let view = PickDoctorViewController()
        view.doctors = doctors
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
        interactor.database = dependencies.doctorsDatabase
        let presenter = AddSchedulePresenter(view: view, interactor: interactor)

        return (view, presenter)
    }
}
